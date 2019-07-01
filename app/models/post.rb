class Post < ApplicationRecord

  # addition attributes from gem
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/system/zilla.jpg"

  # attributes validation
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  # model relationship
  belongs_to :user
  has_many :comments
  
  def post_detail
    comments = []
    self.comments.each do |comment|
      detail = {
        comment: comment,
        user: comment.user.attributes.merge(avatar: comment.user.avatar.url)
      }
      comments << detail
    end
    response = {
      message: "Successfully fecth post detail",
      post: self.attributes.merge(image: self.image.url),
      user: self.user.attributes.merge(avatar: self.user.avatar.url),
      comments: comments
    }
  end

  # create new post
  def save_success
    response = {
      message: "Successfully created post",
      post: self.attributes.merge(image: self.image.url(:medium))
    }
  end

  # failed to create new post
  def failed_seccess
    response = {
      message: "Failed to creat post, due to #{ self.errors.full_messages }",
      post: self
    }
  end

  # success delete post
  def success_delete
    response = {
      message: "Successfully delete post",
      post: self
    }
  end

  def failed_delete
    response = {
      message: "Failed to delete post, due to #{self.errors.full_messages}",
      post: self
    }
  end

  def self.explore
    posts = []
    self.order('RANDOM()').each do |post|
      post = post.attributes.merge(image: post.image.url)
      posts << post
    end
    response = {
      message: "Successfully fetch explore posts",
      posts: posts 
    }
  end

end
