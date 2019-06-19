class Relationship < ApplicationRecord

  # model relation
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  # model validation
  validates :follower_id, presence: true
  validates :followed_id, presence: true

end