class CreateMealPlans < ActiveRecord::Migration[8.1]
  def change
    create_table :meal_plans do |t|
      t.string :title
      t.date :plan_date
      t.text :memo

      t.timestamps
    end
  end
end
