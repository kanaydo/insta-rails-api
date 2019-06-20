class Comment < ApplicationRecord

  # model relationshhip
  belongs_to :post
  belongs_to :user

  # attributes validation
  validates_presence_of :comment, :user_id

end
