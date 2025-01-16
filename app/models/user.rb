class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :replies, dependent: :destroy
  has_many :following, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :followers, class_name: "Follow", foreign_key: "followed_id", dependent: :destroy
  has_one_attached :picture 

  # Validation
  validates :user_type, inclusion: { in: ['admin', 'user'] }
  validates :email, :name, presence: true, uniqueness: true

  def followers_count
    followers.count
  end

  def following_count
    following.count
  end

  def admin?
    user_type == 'admin'
  end

  def user?
    user_type == 'user'
  end

  def following?(user)
    following.exists?(followed_id: user.id)
  end

  def follow(user)
    following.create(followed_id: user.id) unless following?(user)
  end

  def unfollow(user)
    following.find_by(followed_id: user.id)&.destroy
  end
end
