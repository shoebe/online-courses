class User < ApplicationRecord
  validates :username, presence: true,uniqueness: true, length: {in: 1..30}
  validates :password, presence: true, length: {in: 6..30}
  validates :email, presence: true, format: { with: /@/, message: "Is an email"}
end
