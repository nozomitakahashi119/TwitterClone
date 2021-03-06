class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password

  has_many :microposts
  has_many :relationships #自分がフォローしているユーザへの道（中間テーブル）
  has_many :followings, through: :relationships, source: :follow #自分がフォローしているユーザ達の取得
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id' # 自分をフォローしているユーザへの道
  has_many :followers, through: :reverses_of_relationship, source: :user #自分をフォローしているユーザ達の取得
  
  
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end
  #フォロー、アンフォローするときは自分自身ではないか？すでにフォローしてないか？を注意すること
  def unfollow(other_user)
    relationships = self.relationships.find_by(follow_id: other_user.id)
    relationships.destroy if relationships
  end
  
  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  
  has_many :favorites
  has_many :likes, through: :favorites, source: :micropost
  #has_many :reverses_of_favorites, class_name: 'Favorite', foreign_key: 'micropost_id'
  #has_many :favoriter, through: :reverses_of_favorites, source: :user
  
  def favorite(other_micropost)
    #p other_micropost
    #unless self == other_micropost
    puts "OK"
    self.favorites.find_or_create_by(micropost_id: other_micropost.id) #ここが動作してない
    puts "大成功"
    #end
  end

  def unfavorite(other_micropost)
    favorites = self.favorites.find_by(micropost_id: other_micropost.id)
    favorites.destroy if favorites
  end
  
  def favorite?(other_micropost)
    self.likes.include?(other_micropost)
  end
end
