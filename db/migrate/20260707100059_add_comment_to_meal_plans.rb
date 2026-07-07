class AddCommentToMealPlans < ActiveRecord::Migration[8.1]
  def change
    add_column :meal_plans, :comment, :text
  end
end
