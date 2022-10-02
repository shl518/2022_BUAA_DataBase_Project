class Dish < ApplicationRecord
  has_one :canteen, foreign_key: :canteen_id, class_name: :Canteen



end
