class MenuItemsController < ApplicationController
  def update
    menu_item = MenuItem.find(params[:id])
    menu_item.update!(amount: params[:menu_item][:amount])
    redirect_to menu_item.meal_plan_dish.meal_plan
  end
end
