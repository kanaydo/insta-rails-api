class User < ApplicationRecord
  
  # addition attributes from gem
  has_secure_password
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/system/zilla.jpg"

  # attributes validation
  validates_uniqueness_of :username
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  
  # model relationship
  has_many :posts
  has_many :active_relationships, class_name:  "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name:  "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :comments


  # get all user posts
  def user_posts
    posts = []
    self.posts.order("id desc").each do |post|
      post = post.attributes.merge(image: post.image.url)
      posts << post
    end
    posts
  end

  def full_detail
    detail = {
      message: "Successfully fetch user information!",
      user: self.attributes.merge(avatar: self.avatar.url),
      followers: self.followers.count, following: self.following.count,
      posts: self.posts.count
    }
  end

  def profile
    self.attributes.merge(avatar: self.avatar.url)
  end

  def feed
    posts = []
    users = (self.followers + self.following).uniq
    users << self
    users.each do |user|
      user.posts.each do |post|
        posts << post
      end
    end
    posts = posts.sort_by { |e| -e[:created_at].to_i }
    post_list = []
    posts.each do |post|
      post = post.attributes.merge(
        image: post.image.url,
        user: post.user.attributes.merge(avatar: post.user.avatar.url)
      )
      post_list << post
    end
    post_list
  end

end
