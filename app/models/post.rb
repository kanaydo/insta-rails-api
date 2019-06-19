class Post < ApplicationRecord

  # addition attributes from gem
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"

  # attributes validation
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  # model relationship
  belongs_to :user

end
