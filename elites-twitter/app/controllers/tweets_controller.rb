class TweetsController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  
  def index
    
    @tweets = Tweet.all
    @tweet_input = Tweet.new
    puts @tweet_input
  end
  
  def create
    tweet = Tweet.new
    tweet.attributes = tweet_input_param
    tweet.user_id = current_user.id
    
    if tweet.valid? # バリデーションチェック
      tweet.save!
      redirect_to action: :index
    else
      flash[:alert] = tweet.errors.full_messages
      redirect_to action: :index, content: tweet.content
    end
  end
  
  private
  def tweet_input_param
    params.require(:tweet).permit(:user_id, :reply_tweet_id, :content)
  end
end
