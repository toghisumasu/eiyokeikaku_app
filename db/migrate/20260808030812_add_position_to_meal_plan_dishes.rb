class AddPositionToMealPlanDishes < ActiveRecord::Migration[8.1]
  def change
    add_column :meal_plan_dishes, :position, :integer, default: 0, null: false
  end
end
