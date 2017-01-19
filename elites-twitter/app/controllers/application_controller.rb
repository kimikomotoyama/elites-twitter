class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_global_search_variable

  def set_global_search_variable
    @q = nil
    @errors = params[:errors] if params[:errors].present?
    puts "************errors: #{@errors.first}" if params[:errors].present?
    @tweets = Tweet.all.order('updated_at DESC').page(params[:page])
    @tweet_input = Tweet.new(content: params[:content]) 
    keyword = "#{params.dig(:q, :keywords)}"
    
    @q = Tweet.with_keywords(params.dig(:q, :keywords)).ransack(params[:q])
    user = User.find_by_name(params.dig(:q, :keywords))
    if @q.present? || user.present?
      if @q.result.present? && user.present? 
        @tweets = @q.result.page(params[:page])
        @tweets = user.tweets.page(params[:page])
      elsif @q.result.present? 
        @tweets = @q.result.order('updated_at DESC').page(params[:page])
      elsif user.present?
        @tweets = user.tweets.order('updated_at DESC').page(params[:page])
      else
        @tweets = nil
      end
    end
  end
  
  def after_sign_in_path_for(resource)
    tweets_index_path
  end
  
  def after_sign_out_path_for(resource)
    new_user_session_path
  end
  
  protected
  
  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to new_user_session_path, :notice => 'ログインをしてください。'
      ## if you want render 404 page
      ## render :file => File.join(Rails.root, 'public/404'), :formats => [:html], :status => 404, :layout => false
    end
  end
    
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:image])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:profile])
    
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:image])
    devise_parameter_sanitizer.permit(:account_update, keys: [:profile])
  end
  
end
