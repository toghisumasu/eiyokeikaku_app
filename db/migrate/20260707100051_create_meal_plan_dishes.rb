class CreateMealPlanDishes < ActiveRecord::Migration[8.1]
  def change
    create_table :meal_plan_dishes do |t|
      t.references :meal_plan, null: false, index: true
      t.references :dish, null: false, index: true
      t.string :category

      t.timestamps
    end

    add_foreign_key :meal_plan_dishes, :meal_plans
    add_foreign_key :meal_plan_dishes, :dishes
  end
end
