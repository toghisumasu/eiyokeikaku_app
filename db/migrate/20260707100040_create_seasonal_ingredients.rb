class CreateSeasonalIngredients < ActiveRecord::Migration[8.1]
  def change
    create_table :seasonal_ingredients do |t|
      t.references :food, null: false, index: true
      t.integer :month
      t.string :region

      t.timestamps
    end

    add_foreign_key :seasonal_ingredients, :foods
  end
end
