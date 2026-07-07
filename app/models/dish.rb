class Dish < ApplicationRecord
  has_many :dish_ingredients, dependent: :destroy
  has_many :foods, through: :dish_ingredients
  has_many :meal_plan_dishes, dependent: :destroy
end
