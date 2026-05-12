class Food < ApplicationRecord
  has_many :meal_plan_items
  has_many :meal_plans, through: :meal_plan_items
end
