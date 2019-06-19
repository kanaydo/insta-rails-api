class Api::V1::PostsController < ApplicationController

  def index
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

  private
  def post_params
    params.permit(
      :user_id,
      :image,
      :caption
    )
  end
end
