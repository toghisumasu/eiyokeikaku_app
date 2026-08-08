class MealPlansController < ApplicationController
  before_action :set_meal_plan, only: [:show, :edit, :update, :destroy_item, :download_md, :print_hancho]

  def index
    @month = params[:month].present? ? Date.parse("#{params[:month]}-01") : Date.current.beginning_of_month
    @meal_plans_by_date = MealPlan.where(plan_date: @month.beginning_of_month..@month.end_of_month).group_by(&:plan_date)
  end

  def new
    @meal_plan = MealPlan.new
  end

  def create
    @meal_plan = MealPlan.new(meal_plan_params)
    if @meal_plan.save
      redirect_to @meal_plan
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @nutrition = NutritionCalculator.call(@meal_plan)
    @meal_plan_dishes = @meal_plan.meal_plan_dishes
                                   .includes(:dish, menu_items: :food)
                                   .order(:position)
  end

  def edit
    @dishes_by_category = Dish.all.group_by(&:category)
    @selected_dish_ids = @meal_plan.dishes.pluck(:id)
  end

  def update
    @meal_plan.comment = meal_plan_params[:comment]
    @meal_plan.save!

    dish_ids = Array(meal_plan_params[:dish_ids]).reject(&:blank?).map(&:to_i)
    @meal_plan.meal_plan_dishes.where.not(dish_id: dish_ids).destroy_all
    existing_dish_ids = @meal_plan.meal_plan_dishes.pluck(:dish_id)
    next_position = @meal_plan.meal_plan_dishes.maximum(:position).to_i + 1
    (dish_ids - existing_dish_ids).each do |dish_id|
      dish = Dish.find(dish_id)
      meal_plan_dish = @meal_plan.meal_plan_dishes.create!(dish: dish, category: dish.category, position: next_position)
      meal_plan_dish.seed_menu_items_from_dish!
      next_position += 1
    end

    redirect_to @meal_plan
  end

  def print_hancho
    @items = @meal_plan.meal_plan_items.includes(:food)
    @by_color = {
      yellow: @items.select { |i| i.food.color_group == :yellow },
      red:    @items.select { |i| i.food.color_group == :red },
      green:  @items.select { |i| i.food.color_group == :green },
      other:  @items.select { |i| i.food.color_group == :other }
    }
    @totals = {
      energy_kcal:    @items.sum(&:energy_kcal).round(1),
      protein_g:      @items.sum(&:protein_g).round(1),
      fat_g:          @items.sum(&:fat_g).round(1),
      carbohydrate_g: @items.sum(&:carbohydrate_g).round(1),
      calcium_mg:     @items.sum(&:calcium_mg).round(1),
      iron_mg:        @items.sum(&:iron_mg).round(1),
      vitamin_c_mg:   @items.sum(&:vitamin_c_mg).round(1),
      salt_g:         @items.sum(&:salt_g).round(1)
    }
  end

  def destroy_item
    @meal_plan.meal_plan_items.find(params[:item_id]).destroy
    redirect_to @meal_plan
  end

  def download_md
    @items = @meal_plan.meal_plan_items.includes(:food)
    @totals = {
      energy_kcal:    @items.sum { |i| i.energy_kcal }.round(1),
      protein_g:      @items.sum { |i| i.protein_g }.round(1),
      fat_g:          @items.sum { |i| i.fat_g }.round(1),
      carbohydrate_g: @items.sum { |i| i.carbohydrate_g }.round(1)
    }
    md = render_to_string(template: "meal_plans/download_md", formats: [:text], layout: false)
    bom = "\xEF\xBB\xBF"
    send_data bom + md,
      filename: "#{@meal_plan.plan_date}_#{@meal_plan.title}.md",
      type: "text/plain; charset=utf-8",
      disposition: "attachment"
  end

  private

  def set_meal_plan
    @meal_plan = MealPlan.find(params[:id])
  end

  def meal_plan_params
    params.require(:meal_plan).permit(:title, :plan_date, :memo, :comment, dish_ids: [])
  end
end
