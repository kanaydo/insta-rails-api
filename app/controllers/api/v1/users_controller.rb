class Api::V1::UsersController < ApplicationController
  
  def create
    user = User.new user_params
    if user.save
      user = user.attributes.merge(avatar: user.avatar.url)
      response = {
        message: "Successfully created user!",
        user: user
      }
      status = :ok
    else
      user = user.attributes.merge(avatar: user.avatar.url)
      response = {
        message: "Failed to create user due to #{ user.errors.full_messages }",
        user: user
      }
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
      response = {
        message: "Failed to fetch user information!",
        user: nil
      }
      status = :not_found 
    end
    render json: response, status: status
  end

  def update
    user = User.find params[:id]
    if user.update user_params
      response = {
        message: "Successfully updated user information!",
        user: user
      }
      status = :ok
    else
      response = {
        message: "Failed to update user information!, due to #{ user.errors.full_messages }",
        user: user
      }
      status = :ok
    end
    render json: response, status: status 
  end

  def followers
    user = User.find params[:id]
    response = {
      message: "Successfully fetch #{ user.username } followers",
      followers: user.followers
    }
    render json: response, status: :ok
  end

  def following
    user = User.find params[:id]
    response = {
      message: "Successfully fetch #{ user.username } following",
      followers: user.following
    }
    render json: response, status: :ok
  end

  def follow
    user = User.find params[:id]
    follow = user.passive_relationships.new(follower_id: params[:follower_id])
    if follow.save
      status = :ok
      response = {
        message: "Successfully following #{ user.username }",
        user: user
      }
    else
      status = :unprocessable_entity 
      response = {
        message: "Successfully following #{ user.username }",
        user: user
      }
    end
    render json: response, status: status
  end

  def unfollow
  end
  
  def posts
    user = User.find params[:id]
    response = {
      message: "Successfully fecth user posts",
      posts: user.user_posts
    }
    render json: response, status: :ok
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
