class Dish < ApplicationRecord
  has_one :canteen, foreign_key: :canteen_id, class_name: :Canteen

  def to_json_for_frontend
    h = Hash.new
    h.store("dish_id", self[:id])
    h.store("dish_name", self[:name])
    h.store("dish_price", self[:price])
    h.store("canteen_name", self[:canteen_name])
    h.store("dish_picture_id", nil)
    h.store("dish_star", self[:star])
    h.as_json
  end

end
