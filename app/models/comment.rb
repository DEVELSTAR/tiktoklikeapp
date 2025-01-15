class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :replies, dependent: :destroy

  validates :content, presence: true
end
