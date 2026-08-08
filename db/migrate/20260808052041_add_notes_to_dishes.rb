class AddNotesToDishes < ActiveRecord::Migration[8.1]
  def change
    add_column :dishes, :notes, :text
  end
end
