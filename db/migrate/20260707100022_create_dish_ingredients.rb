class CreateDishIngredients < ActiveRecord::Migration[8.1]
  def change
    create_table :dish_ingredients do |t|
      t.references :dish, null: false, index: true
      t.references :food, null: false, index: true
      t.decimal :amount_g, precision: 8, scale: 2

      t.timestamps
    end

    add_foreign_key :dish_ingredients, :dishes
    add_foreign_key :dish_ingredients, :foods
  end
end
