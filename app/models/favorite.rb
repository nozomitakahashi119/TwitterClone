class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :micropost#, class_name: 'User'
  #belongs_to :favorite, class_name: 'Micropost'
end