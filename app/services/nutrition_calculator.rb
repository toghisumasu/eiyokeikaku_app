class NutritionCalculator
  NUTRIENTS = %i[
    energy_kcal protein_g fat_g carbohydrate_g
    calcium_mg iron_mg vitamin_c_mg salt_g
  ].freeze

  def self.call(meal_plan)
    ingredients = meal_plan.meal_plan_dishes
                            .includes(dish: { dish_ingredients: :food })
                            .flat_map { |meal_plan_dish| meal_plan_dish.dish.dish_ingredients }

    NUTRIENTS.each_with_object({}) do |nutrient, totals|
      total = ingredients.sum { |ingredient| ingredient.food.public_send(nutrient).to_f * ingredient.amount_g / 100.0 }
      totals[nutrient] = total.round(1)
    end
  end
end
