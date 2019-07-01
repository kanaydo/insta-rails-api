class Comment < ApplicationRecord

  # model relationshhip
  belongs_to :post
  belongs_to :user

  # attributes validation
  validates_presence_of :comment, :user_id

  
  def success_save
    response = {
      message: "Successfully comment this post",
      comment: self
    }
  end

  def failed_save
    response = {
      message: "Failed commenting this post due to #{self.errors.full_messages}",
      comment: self
    }
  end

end
