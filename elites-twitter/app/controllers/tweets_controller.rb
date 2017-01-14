class TweetsController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  
  def index
    @q = nil
    @errors = params[:errors] if params[:errors].present?
    @tweets = Tweet.all.order('updated_at DESC').page(params[:page])
    @tweet_input = Tweet.new(content: params[:content]) 
    keyword = #{params.dig(:q, :keywords)}"
    
    @q = Tweet.with_keywords(params.dig(:q, :keywords)).ransack(params[:q])
    user = User.find_by_name(params.dig(:q, :keywords))
    if @q.present? || user.present?
      puts '**************************** present'
      puts "user is: #{user.name}" if user.present?
      if @q.result.present? && user.present? 
        puts '**************************** both present'
        puts "**************************** @q is: #{@q.result.first.content}"
        puts "**************************** user is: #{user.tweets.first.content}"
        ### ここをcombineしたい #######
        @tweets = @q.result.page(params[:page])
        @tweets = user.tweets.page(params[:page])
        ###############################
      elsif @q.result.present? 
        puts '**************************** Tweet content present'
        puts "**************************** @q is: #{@q.result.first.content}"
        @tweets = @q.result.order('updated_at DESC').page(params[:page])
      elsif user.present?
        puts '**************************** User name present'
        puts "**************************** user content is: #{user.tweets.first.content}"
        @tweets = user.tweets.order('updated_at DESC').page(params[:page])
      else
        @tweets = nil
      end
      
      
    end
  end
  
  def create
    tweet = Tweet.new
    tweet.attributes = tweet_input_param
    tweet.user_id = current_user.id
    
    if tweet.valid? # バリデーションチェック
      tweet.save!
      flash[:notice] = "投稿しました"
      redirect_to action: :index
    else
      flash[:alert] = tweet.errors.full_messages
      redirect_to action: :index, content: tweet.content, errors: tweet.errors.full_messages
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
