class Food < ApplicationRecord
  has_many :meal_plan_items
  has_many :meal_plans, through: :meal_plan_items
  has_many :dish_ingredients
  has_many :dishes, through: :dish_ingredients
  has_many :seasonal_ingredients

  YELLOW_CATEGORIES = %w[01 02 03 05 14 15 16]
  RED_CATEGORIES    = %w[10 11 12]
  GREEN_CATEGORIES  = %w[06 07 08 09]

  def color_group
    return :yellow if YELLOW_CATEGORIES.include?(food_category)
    return :red    if RED_CATEGORIES.include?(food_category)
    return :green  if GREEN_CATEGORIES.include?(food_category)
    case food_category
    when '04' then :red
    when '13' then :green
    else :other
    end
  end

  def color_group_label
    { yellow: '黄', red: '赤', green: '緑', other: 'その他' }[color_group]
  end
end
