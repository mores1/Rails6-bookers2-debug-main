class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  
  
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
   # フォローするユーザーから見た中間テーブル
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # フォローされているユーザーから見た中間テーブル
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  
  
  

    # 中間テーブルactive_relationshipsを通って、フォローされる側(followed)を集める処理をfollowingsと命名
  # フォローしているユーザーの情報がわかるようになる
  has_many :followings, through: :active_relationships, source: :followed
   # 中間テーブルpassive_relationshipsを通って、フォローする側(follower)を集める処理をfollowingsと命名
  #　フォローされているユーザーの情報がわかるようになる
  has_many :followers, through: :passive_relationships, source: :follower
  
  
  has_one_attached :profile_image
  
  
  
  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }
  
  
    # フォローする
  def follow(user_id)
    active_relationships.create(followed_id: user_id)
  end

  # フォローを外す
  def unfollow(user_id)
    active_relationships.find_by(followed_id: user_id).destroy
  end

  # すでにフォローしているのか確認
  def following?(user)
    followings.include?(user)
  end

  
  
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
end
