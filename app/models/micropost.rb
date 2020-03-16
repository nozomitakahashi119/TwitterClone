class Micropost < ApplicationRecord
  belongs_to :user
  
  has_many :favorites #追記
  has_many :users, through: :favorites, source: :user #追記
  
  validates :content, presence: true, length: { maximum: 255 }
  
end