class NutritionCalculator
  NUTRIENTS = %i[
    energy_kcal protein_g fat_g carbohydrate_g
    calcium_mg iron_mg vitamin_c_mg salt_g
  ].freeze

  def self.call(meal_plan)
    menu_items = meal_plan.meal_plan_dishes
                           .includes(menu_items: :food)
                           .flat_map(&:menu_items)

    NUTRIENTS.each_with_object({}) do |nutrient, totals|
      total = menu_items.sum { |menu_item| menu_item.food.public_send(nutrient).to_f * menu_item.amount / 100.0 }
      totals[nutrient] = total.round(1)
    end
  end
end
