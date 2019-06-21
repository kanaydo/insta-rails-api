class Api::V1::UsersController < ApplicationController
  
  def create
    user = User.new user_params
    if user.save
      response = user.operation_success
      status = :ok
    else
      response = user.operation_failed
      status = :unprocessable_entity 
    end
    render json: response, status: status
  end

  def show
    user = User.find params[:id]
    if user
      response = user.full_detail
      status = :ok
    else
      response = User.user_not_found
      status = :not_found 
    end
    render json: response, status: status
  end

  def update
    user = User.find params[:id]
    if user.update user_params
      response = user.operation_success
      status = :ok
    else
      response = user.operation_failed
      status = :ok
    end
    render json: response, status: status 
  end

  def followers
    user = User.find params[:id]
    response = user.followers_info
    render json: response, status: :ok
  end

  def following
    user = User.find params[:id]
    response = user.following_info
    render json: response, status: :ok
  end

  def follow
    user = User.find params[:id]
    follow = user.passive_relationships.new(follower_id: params[:follower_id])
    if follow.save
      status = :ok
      response = follow.success_follow
    else
      status = :unprocessable_entity 
      response = follow.failed_follow
    end
    render json: response, status: status
  end

  def unfollow
  end
  
  def posts
    user = User.find params[:id]
    render json: user.all_posts, status: :ok
  end

  private
  def user_params
    params.permit(
      :name,
      :username,
      :email,
      :password,
      :caption,
      :avatar
    )
  end

end
