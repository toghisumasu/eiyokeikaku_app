class MealPlan < ApplicationRecord
  has_many :meal_plan_items, dependent: :destroy
  has_many :foods, through: :meal_plan_items

  validates :title, presence: true
  validates :plan_date, presence: true
end
