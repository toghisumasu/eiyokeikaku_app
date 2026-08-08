class ChangeGramsPrecisionInMealPlanItems < ActiveRecord::Migration[8.1]
  def change
    change_column :meal_plan_items, :grams, :decimal, precision: 8, scale: 1
  end
end
