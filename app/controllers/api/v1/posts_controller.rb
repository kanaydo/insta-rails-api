class Api::V1::PostsController < ApplicationController

  def explore
    render json: Post.explore, status: :ok
  end

  def feed
    user = User.find params[:id]
    response = user.post_feeds
    render json: response, status: :ok
  end

  def create
    post = Post.new post_params
    if post.save
      response = post.save_success
      status = :ok
    else
      response = post.failed_seccess
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
      response = post.success_delete
      status = :ok
    else
      response = post.failed_delete
      status = :not_modified
    end
    render json: response, status: status
  end

  def comment
    post = Post.find params[:id]
    comment = post.comments.new comment_params
    if comment.save
      status = :ok
      response = comment.success_save
    else
      status = :unprocessable_entity
      response = comment.failed_save
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
