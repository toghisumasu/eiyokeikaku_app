class BackfillMenuItemsFromDishIngredients < ActiveRecord::Migration[8.1]
  class MigrationMealPlanDish < ActiveRecord::Base
    self.table_name = "meal_plan_dishes"
  end

  class MigrationDishIngredient < ActiveRecord::Base
    self.table_name = "dish_ingredients"
  end

  class MigrationMenuItem < ActiveRecord::Base
    self.table_name = "menu_items"
  end

  def up
    MigrationMealPlanDish.reset_column_information
    MigrationDishIngredient.reset_column_information
    MigrationMenuItem.reset_column_information

    MigrationMealPlanDish.find_each.with_index do |meal_plan_dish, index|
      meal_plan_dish.update_column(:position, index) if meal_plan_dish.position.to_i.zero?

      next if MigrationMenuItem.exists?(meal_plan_dish_id: meal_plan_dish.id)

      MigrationDishIngredient.where(dish_id: meal_plan_dish.dish_id).find_each do |ingredient|
        MigrationMenuItem.create!(
          meal_plan_dish_id: meal_plan_dish.id,
          food_id: ingredient.food_id,
          amount: ingredient.amount_g
        )
      end
    end
  end

  def down
    # no-op: MenuItem is a new table, dropped by CreateMenuItems#down if rolled back
  end
end
