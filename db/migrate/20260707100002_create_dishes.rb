class CreateDishes < ActiveRecord::Migration[8.1]
  def change
    create_table :dishes do |t|
      t.string :name
      t.string :category
      t.text :memo

      t.timestamps
    end
  end
end
