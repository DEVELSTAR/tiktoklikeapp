class Course < ApplicationRecord
  has_and_belongs_to_many :students
  validates :name, presence: true
end
