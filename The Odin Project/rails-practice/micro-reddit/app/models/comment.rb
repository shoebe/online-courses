class Comment < ApplicationRecord
  validates :user_id, presence: true
  validates :post_id, presence: true
  validates :body, length: {minimum:1}
  belongs_to :user
  belongs_to :post
end
