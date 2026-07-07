class MealPlan < ApplicationRecord
  has_many :meal_plan_items, dependent: :destroy
  has_many :foods, through: :meal_plan_items
  has_many :meal_plan_dishes, dependent: :destroy
  has_many :dishes, through: :meal_plan_dishes

  validates :title, presence: true
  validates :plan_date, presence: true
end
