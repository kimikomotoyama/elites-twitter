class UsersController < ApplicationController
  def show
    @tweets = User.find(params[:id]).tweets.order('updated_at DESC').page(params[:page])
    @user = User.find(params[:id])
  end
end
