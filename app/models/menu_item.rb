class MenuItem < ApplicationRecord
  belongs_to :meal_plan_dish
  belongs_to :food

  validates :amount, presence: true, numericality: { greater_than: 0 }

  # 栄養素計算（per 100g → 指定グラム数分）
  def energy_kcal
    food.energy_kcal * amount / 100.0
  end

  def protein_g
    food.protein_g * amount / 100.0
  end

  def fat_g
    food.fat_g * amount / 100.0
  end

  def carbohydrate_g
    food.carbohydrate_g * amount / 100.0
  end

  def calcium_mg
    food.calcium_mg * amount / 100.0
  end

  def iron_mg
    food.iron_mg * amount / 100.0
  end

  def vitamin_c_mg
    food.vitamin_c_mg * amount / 100.0
  end

  def salt_g
    food.salt_g * amount / 100.0
  end
end
