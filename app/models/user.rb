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

  def post_feeds
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
    response = {
      message: "Successfully fecth user feeds",
      posts: post_list
    } 
  end

  # success saved user response
  def save_seccess
    response = {
      status: 200,
      message: "Successfully create user!",
      user: self.attributes.merge(avatar: self.avatar.url)
    }
  end

  # failed saving user response
  def save_failed
    response = {
      status: 422,
      message: "Failed to create user!, due to #{ self.errors.full_messages }",
      user: self
    }
  end

  # success update user response
  def update_seccess
    response = {
      status: 200,
      message: "Successfully update user information!",
      user: self.attributes.merge(avatar: self.avatar.url)
    }
  end

  # failed updating user response
  def update_failed
    response = {
      status: 422,
      message: "Failed updating user information!, due to #{ self.errors.full_messages }",
      user: self
    }
  end

  def self.not_found
    response = {
      message: "Failed to fetch user information!",
      user: nil
    }
  end

  # success login response
  def session_seccess
    response = {
      status: 200,
      message: "Successfully Login as #{self.username}",
      user: self.attributes.merge(avatar: self.avatar.url)
    }
  end

  # login failed response
  def self.session_failed
    response = {
      status: 422,
      message: "Failed to login because username or password wrong",
      user: self.new.attributes.merge(avatar: nil)
    }
  end

  # fecth user follower information
  def followers_info
    followers = []
    self.followers.each do |follower|
      followers << follower.attributes.merge(avatar: follower.avatar.url)
    end
    response = {
      message: "Successfully fetch #{ self.username } followers",
      relations: followers
    }
  end

  # fecth user following information
  def following_info
    following = []
    self.following.each do |follower|
      following << follower.attributes.merge(avatar: follower.avatar.url)
    end
    response = {
      message: "Successfully fetch #{ self.username } following",
      relations: following
    }
  end

  def all_posts
    response = {
      message: "Successfully fecth user posts",
      posts: self.user_posts
    }
  end

  # check relation with another user
  def check_relation_with friend_id
    response = {
      message: "Successfully fecth user relation",
      following: self.active_relationships.where(follower_id: friend_id).present?,
      follower: self.passive_relationships.where(follower_id: friend_id).present?
    }
  end

end
