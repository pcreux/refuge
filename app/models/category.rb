class Category < ActiveRecord::Base
  has_many :ads, :dependent => :destroy
end

