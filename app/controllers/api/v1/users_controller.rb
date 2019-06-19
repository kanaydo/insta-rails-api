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
      new_user = user.attributes.merge(
        avatar: user.avatar.url, 
        posts: user.user_posts,
        followers: user.followers.count,
        following: user.following.count
      )
      response = {
        message: "Successfully fetch user information!",
        user: new_user,
      }
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
      user = user.attributes.merge(avatar: user.avatar.url)
      response = {
        message: "Successfully updated user information!",
        user: user
      }
      status = :ok
    else
      user = user.attributes.merge(avatar: user.avatar.url)
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
    followers = user.followers
    response = {
      message: "Successfully fetch #{ user.username } followers",
      followers: followers
    }
    render json: response, status: :ok
  end

  def following
    user = User.find params[:id]
    following = user.following
    response = {
      message: "Successfully fetch #{ user.username } following",
      followers: following
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
