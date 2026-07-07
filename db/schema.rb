# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_07_07_100059) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "dish_ingredients", force: :cascade do |t|
    t.decimal "amount_g", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.bigint "dish_id", null: false
    t.bigint "food_id", null: false
    t.datetime "updated_at", null: false
    t.index ["dish_id"], name: "index_dish_ingredients_on_dish_id"
    t.index ["food_id"], name: "index_dish_ingredients_on_food_id"
  end

  create_table "dishes", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.text "memo"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "foods", force: :cascade do |t|
    t.decimal "calcium_mg"
    t.decimal "carbohydrate_g"
    t.datetime "created_at", null: false
    t.decimal "energy_kcal"
    t.decimal "fat_g"
    t.string "food_category"
    t.string "food_code"
    t.string "food_name"
    t.decimal "iron_mg"
    t.decimal "protein_g"
    t.decimal "salt_g"
    t.datetime "updated_at", null: false
    t.decimal "vitamin_a_ug"
    t.decimal "vitamin_b1_mg"
    t.decimal "vitamin_b2_mg"
    t.decimal "vitamin_c_mg"
  end

  create_table "meal_plan_dishes", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.bigint "dish_id", null: false
    t.bigint "meal_plan_id", null: false
    t.datetime "updated_at", null: false
    t.index ["dish_id"], name: "index_meal_plan_dishes_on_dish_id"
    t.index ["meal_plan_id"], name: "index_meal_plan_dishes_on_meal_plan_id"
  end

  create_table "meal_plan_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "food_id", null: false
    t.decimal "grams"
    t.bigint "meal_plan_id", null: false
    t.datetime "updated_at", null: false
    t.index ["food_id"], name: "index_meal_plan_items_on_food_id"
    t.index ["meal_plan_id"], name: "index_meal_plan_items_on_meal_plan_id"
  end

  create_table "meal_plans", force: :cascade do |t|
    t.text "comment"
    t.datetime "created_at", null: false
    t.text "memo"
    t.date "plan_date"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "seasonal_ingredients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "food_id", null: false
    t.integer "month"
    t.string "region"
    t.datetime "updated_at", null: false
    t.index ["food_id"], name: "index_seasonal_ingredients_on_food_id"
  end

  add_foreign_key "dish_ingredients", "dishes"
  add_foreign_key "dish_ingredients", "foods"
  add_foreign_key "meal_plan_dishes", "dishes"
  add_foreign_key "meal_plan_dishes", "meal_plans"
  add_foreign_key "meal_plan_items", "foods"
  add_foreign_key "meal_plan_items", "meal_plans"
  add_foreign_key "seasonal_ingredients", "foods"
end
