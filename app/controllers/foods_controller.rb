class FoodsController < ApplicationController
  def search
    @meal_plan_id = params[:meal_plan_id]

    if params[:q].present?
      @foods = Food.where("food_name LIKE ?", "%#{params[:q]}%")
                   .order(:food_code)
                   .limit(30)
    else
      @foods = []
    end
  end

  def add_to_plan
    meal_plan = MealPlan.find(params[:meal_plan_id])
    meal_plan.meal_plan_items.create!(
      food_id: params[:food_id],
      grams: params[:grams]
    )
    redirect_to meal_plan
  end
end
