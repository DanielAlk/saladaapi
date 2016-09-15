class Shop < ActiveRecord::Base
  belongs_to :user
  belongs_to :shed
  belongs_to :category
end
