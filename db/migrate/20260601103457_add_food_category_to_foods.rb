class AddFoodCategoryToFoods < ActiveRecord::Migration[8.1]
  def change
    add_column :foods, :food_category, :string
  end
end
