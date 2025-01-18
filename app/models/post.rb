class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments, as: :commentable

  has_many_attached :images 
  validates :title, :content, presence: true
end
