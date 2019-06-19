class User < ApplicationRecord
  
  # addition attributes from gem
  has_secure_password
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"

  # attributes validation
  validates_uniqueness_of :username
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  
  # model relationship
  has_many :posts
  has_many :active_relationships, class_name:  "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name:  "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower


  # get all user posts
  def user_posts
    posts = []
    self.posts.each do |post|
      new_post = {
        id: post.id,
        image: post.image.url(:medium)
      }
      posts << new_post
    end
    posts
  end

end
