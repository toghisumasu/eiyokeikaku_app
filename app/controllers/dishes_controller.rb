class DishesController < ApplicationController
  def index
    @dishes_by_category = Dish.all.group_by(&:category)
  end
end
