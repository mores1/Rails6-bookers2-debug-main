class RelationshipsController < ApplicationController
  
  before_action :authenticate_user!
  
  def create
    current_user.follow(params[:user_id])
    redirect_to request.referer
  end
  
  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end
  
  #フォロー一覧
  def follower
    user = User.find(params[:user_id])
    @users = user.followings
  end
  
  #フォローされてる一覧
  def followed
    user = User.find(params[:user_id])
    @users = user.followers
  end
  
  
end
