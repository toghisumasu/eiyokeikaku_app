class DishesController < ApplicationController
  def index
    @regions = SeasonalIngredient.distinct.order(:region).pluck(:region)
    @months  = SeasonalIngredient.distinct.order(:month).pluck(:month)

    @month  = params[:month].presence&.to_i || Date.current.month
    @region = params[:region].presence || @regions.first

    @seasonal_foods = Food.joins(:seasonal_ingredients)
                           .where(seasonal_ingredients: { month: @month, region: @region })
                           .distinct

    @dishes_by_category = Dish.includes(dish_ingredients: :food)
                               .joins(dish_ingredients: :food)
                               .where(dish_ingredients: { food_id: @seasonal_foods.select(:id) })
                               .distinct
                               .group_by(&:category)
  end
end
