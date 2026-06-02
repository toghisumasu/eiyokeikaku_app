class MealPlansController < ApplicationController
  before_action :set_meal_plan, only: [:show, :destroy_item, :download_md, :print_hancho]

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
    @items = @meal_plan.meal_plan_items.includes(:food)
    @totals = {
      energy_kcal:    @items.sum(&:energy_kcal).round(1),
      protein_g:      @items.sum(&:protein_g).round(1),
      fat_g:          @items.sum(&:fat_g).round(1),
      carbohydrate_g: @items.sum(&:carbohydrate_g).round(1),
      calcium_mg:     @items.sum(&:calcium_mg).round(1),
      iron_mg:        @items.sum(&:iron_mg).round(1),
      vitamin_c_mg:   @items.sum(&:vitamin_c_mg).round(1),
      salt_g:         @items.sum(&:salt_g).round(1),
    }
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
    params.require(:meal_plan).permit(:title, :plan_date, :memo)
  end
end
