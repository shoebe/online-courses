class Post < ApplicationRecord
  validates :user_id, presence: true
  validates :url, presence: true
  belongs_to :user
  has_many :comments
end
