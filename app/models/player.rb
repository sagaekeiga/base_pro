class Player < ActiveRecord::Base
    validates :image, uniqueness: true
end
