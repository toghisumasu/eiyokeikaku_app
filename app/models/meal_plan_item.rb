class MealPlanItem < ApplicationRecord
  belongs_to :meal_plan
  belongs_to :food

  validates :grams, presence: true, numericality: { greater_than: 0 }

  # 栄養素計算（per 100g → 指定グラム数分）
  def energy_kcal
    food.energy_kcal * grams / 100.0
  end

  def protein_g
    food.protein_g * grams / 100.0
  end

  def fat_g
    food.fat_g * grams / 100.0
  end

  def carbohydrate_g
    food.carbohydrate_g * grams / 100.0
  end

  def calcium_mg
    food.calcium_mg * grams / 100.0
  end

  def iron_mg
    food.iron_mg * grams / 100.0
  end

  def vitamin_c_mg
    food.vitamin_c_mg * grams / 100.0
  end

  def salt_g
    food.salt_g * grams / 100.0
  end
end
