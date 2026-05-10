class CreateFoods < ActiveRecord::Migration[8.1]
  def change
    create_table :foods do |t|
      t.string :food_code
      t.string :food_name
      t.decimal :energy_kcal
      t.decimal :protein_g
      t.decimal :fat_g
      t.decimal :carbohydrate_g
      t.decimal :calcium_mg
      t.decimal :iron_mg
      t.decimal :vitamin_a_ug
      t.decimal :vitamin_b1_mg
      t.decimal :vitamin_b2_mg
      t.decimal :vitamin_c_mg
      t.decimal :salt_g

      t.timestamps
    end
  end
end
