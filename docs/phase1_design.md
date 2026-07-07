# フェーズ1 設計書

## 目的
旬の食材→主菜→副菜→栄養価分析→月間献立表のワークフローを支えるテーブルを追加する。

## 追加migration（4本）

### 1. dishes
rails g migration CreateDishes name:string category:string memo:text

### 2. dish_ingredients
rails g migration CreateDishIngredients dish:references food:references amount_g:decimal

### 3. seasonal_ingredients
rails g migration CreateSeasonalIngredients food:references month:integer region:string

### 4. meal_plan_dishes
rails g migration CreateMealPlanDishes meal_plan:references dish:references category:string

## 既存テーブル変更（1本）
rails g migration AddCommentToMealPlans comment:text

## モデルの関連
Dish          has_many :dish_ingredients
              has_many :foods, through: :dish_ingredients
              has_many :meal_plan_dishes

Food          has_many :dish_ingredients
              has_many :dishes, through: :dish_ingredients
              has_many :seasonal_ingredients

MealPlan      has_many :meal_plan_dishes
              has_many :dishes, through: :meal_plan_dishes

SeasonalIngredient  belongs_to :food

## 栄養価計算の経路
MealPlan → meal_plan_dishes → dish → dish_ingredients（amount_g）→ food（栄養価カラム）→ 合算してPFC・エネルギーを算出（Ruby純粋関数）

## 注意事項
- 栄養価計算はRuby側（A層）で行う。LLMに計算させない
- meal_plan_itemsは既存互換のため削除しない
