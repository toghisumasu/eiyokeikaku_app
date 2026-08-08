class MealPlanDish < ApplicationRecord
  belongs_to :meal_plan
  belongs_to :dish
  has_many :menu_items, dependent: :destroy

  def seed_menu_items_from_dish!
    dish.dish_ingredients.each do |ingredient|
      menu_items.create!(food_id: ingredient.food_id, amount: ingredient.amount_g)
    end
  end
end
