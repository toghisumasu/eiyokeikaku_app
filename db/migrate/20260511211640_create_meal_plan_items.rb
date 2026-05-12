class CreateMealPlanItems < ActiveRecord::Migration[8.1]
  def change
    create_table :meal_plan_items do |t|
      t.references :meal_plan, null: false, foreign_key: true
      t.references :food, null: false, foreign_key: true
      t.decimal :grams

      t.timestamps
    end
  end
end
