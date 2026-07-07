class MealPlanDish < ApplicationRecord
  belongs_to :meal_plan
  belongs_to :dish
end
