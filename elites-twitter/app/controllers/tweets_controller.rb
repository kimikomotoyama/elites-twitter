class TweetsController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  
  def search
    index
    render :index
  end
  
  def index
  end
  
  def create
    tweet = Tweet.new
    tweet.attributes = tweet_input_param
    tweet.user_id = current_user.id
    
    if tweet.valid? # バリデーションチェック
      tweet.save!
      flash[:notice] = "投稿しました"
      if tweet.reply_tweet_id.present?
        redirect_to action: :show, :id => tweet.reply_tweet_id
      else
        redirect_to action: :index
      end
    else
      flash[:alert] = tweet.errors.full_messages
      if tweet.reply_tweet_id.present?
        redirect_to action: :show, :id => tweet.reply_tweet_id, content: tweet.content, errors: tweet.errors.full_messages
      else
        redirect_to action: :index, content: tweet.content, errors: tweet.errors.full_messages
      end
    end
  end
  
  def edit
    @tweet_input = Tweet.find(params[:id])
    @tweet_input.content = params[:content] if params[:content].present?
    if params[:errors].present?
      @errors = params[:errors] 
      params[:content] = nil
    end
  end
  
  def update
    puts '***************** update'
    @tweet_input = Tweet.find(params[:id])
    @tweet_input.attributes = tweet_input_param
    @tweet_input.user_id = current_user.id
    if @tweet_input.valid? # バリデーションチェック
      @tweet_input.save!
      flash[:notice] = "更新しました"
      redirect_to action: :index
    else
      flash[:alert] = @tweet_input.errors.full_messages
      redirect_to action: :edit, content: @tweet_input.content, errors: @tweet_input.errors.full_messages
    end
  end
  
  def show
    @current_user = User.find(current_user.id)
    @tweet = Tweet.find(params[:id])
    @reply_tweets = Tweet.where(["reply_tweet_id = ?", @tweet.id]).order('updated_at DESC').page(params[:page])
    
    #reply
    @tweet_input = Tweet.new(content: params[:content]) 
    @errors = params[:errors] if params[:errors].present?
    
  end
  
  def destroy
    @tweet_input = Tweet.find(params[:id])
    @tweet_input.destroy
    flash[:notice] = "削除しました"
    redirect_to action: :index
  end
  
  private
  def tweet_input_param
    params.require(:tweet).permit(:user_id, :reply_tweet_id, :content)
  end
end
