class Api::V1::PostsController < ApplicationController

  def index
  end

  def explore
    render json: Post.explore, status: :ok
  end

  def feed
    user = User.find params[:id]
    response = {
      message: "Successfully fetch all post",
      posts: user.feed
    }
    render json: response, status: :ok
  end

  def create
    post = Post.new post_params
    if post.save
      post = post.attributes.merge(image: post.image.url(:medium))
      response = {
        message: "Successfully created post",
        post: post
      }
      status = :ok
    else
      response = {
        message: "Failed to creat post, due to #{ post.errors.full_messages }",
        post: post
      }
      status = :unprocessable_entity
    end
    render json: response, status: status
  end

  def show
    post = Post.find params[:id]
    render json: post.post_detail, status: :ok
  end

  def destroy
    post = Post.find params[:id]
    if post.destroy
      status = :ok
      response = {
        message: "Successfully delete post",
        post: post
      }
    else
      status = :not_modified
      response = {
        message: "Successfully delete post",
        post: post
      }
    end
    render json: response, status: status
  end

  def comment
    post = Post.find params[:id]
    comment = post.comments.new comment_params
    if comment.save
      status = :ok
      response = {
        message: "Successfully comment this post",
        comment: comment
      }
    else
      status = :unprocessable_entity
      response = {
        message: "Failed to create comment, due to #{ comment.errors.full_messages }",
        comment: comment
      }
    end
    render json: response, status: status
  end

  private
  def post_params
    params.permit(
      :user_id,
      :image,
      :caption
    )
  end
  
  def comment_params
    params.permit(
      :user_id,
      :comment
    )
  end

end
