class CreateMenuItems < ActiveRecord::Migration[8.1]
  def change
    create_table :menu_items do |t|
      t.references :meal_plan_dish, null: false, foreign_key: true
      t.references :food, null: false, foreign_key: true
      t.decimal :amount, precision: 8, scale: 1

      t.timestamps
    end
  end
end
