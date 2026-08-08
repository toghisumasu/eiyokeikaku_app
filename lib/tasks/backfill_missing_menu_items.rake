namespace :maintenance do
  desc "MenuItemが1件も無いMealPlanDishに対し、Dishの標準レシピ(DishIngredient)からコピーして補完する"
  task backfill_missing_menu_items: :environment do
    MealPlanDish.left_joins(:menu_items).where(menu_items: { id: nil }).distinct.find_each do |meal_plan_dish|
      meal_plan_dish.seed_menu_items_from_dish!
      puts "MealPlanDish##{meal_plan_dish.id} (#{meal_plan_dish.dish.name}): #{meal_plan_dish.menu_items.count}件のMenuItemを補完"
    end
  end
end
