# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# --- 7月・近畿の旬の食材 ---
seasonal_ingredients_july_kinki = [
  { label: "なす",         food_name: "（なす類）　なす　果実　生" },
  { label: "トマト",       food_name: "（トマト類）　赤色トマト　果実　生" },
  { label: "きゅうり",     food_name: "きゅうり　果実　生" },
  { label: "ピーマン",     food_name: "（ピーマン類）　青ピーマン　果実　生" },
  { label: "えだまめ",     food_name: "えだまめ　生" },
  { label: "とうもろこし", food_name: "（とうもろこし類）　スイートコーン　未熟種子　生" },
  { label: "オクラ",       food_name: "オクラ　果実　生" },
  { label: "ゴーヤ",       food_name: "にがうり　果実　生" },
  { label: "冬瓜",         food_name: "とうがん　果実　生" },
  { label: "しょうが",     food_name: "（しょうが類）　しょうが　根茎　皮なし　生" },
]

seasonal_ingredients_july_kinki.each do |item|
  food = Food.find_by(food_name: item[:food_name])
  next unless food

  SeasonalIngredient.find_or_create_by!(food: food, month: 7, region: "近畿")
end

# --- サンプル料理（主菜2・副菜2・汁物1）と使用食材（幼児1人前グラム数） ---
dish_definitions = [
  {
    name: "鶏肉のから揚げ",
    category: "主菜",
    ingredients: [
      { food_name: "＜鳥肉類＞　にわとり　［若どり・主品目］　もも　皮つき　生", amount_g: 50 },
      { food_name: "＜調味料類＞　（しょうゆ類）　こいくちしょうゆ", amount_g: 5 },
      { food_name: "＜でん粉・でん粉製品＞　（でん粉類）　じゃがいもでん粉", amount_g: 5 },
    ]
  },
  {
    name: "さけの塩焼き",
    category: "主菜",
    ingredients: [
      { food_name: "＜魚類＞　（さけ・ます類）　しろさけ　塩ざけ", amount_g: 50 },
    ]
  },
  {
    name: "ほうれんそうのごま和え",
    category: "副菜",
    ingredients: [
      { food_name: "ほうれんそう　葉　通年平均　生", amount_g: 40 },
      { food_name: "ごま　いり", amount_g: 3 },
    ]
  },
  {
    name: "きゅうりの酢の物",
    category: "副菜",
    ingredients: [
      { food_name: "きゅうり　果実　生", amount_g: 30 },
      { food_name: "＜調味料類＞　（食塩類）　食塩", amount_g: 0.5 },
    ]
  },
  {
    name: "みそ汁（わかめ・豆腐）",
    category: "汁物",
    ingredients: [
      { food_name: "だいず　［豆腐・油揚げ類］　絹ごし豆腐", amount_g: 30 },
      { food_name: "わかめ　乾燥わかめ　素干し", amount_g: 2 },
      { food_name: "＜調味料類＞　（みそ類）　米みそ　淡色辛みそ", amount_g: 8 },
    ]
  },
]

dish_definitions.each do |dish_def|
  dish = Dish.find_or_create_by!(name: dish_def[:name]) do |d|
    d.category = dish_def[:category]
  end

  dish_def[:ingredients].each do |ingredient|
    food = Food.find_by(food_name: ingredient[:food_name])
    next unless food

    DishIngredient.find_or_create_by!(dish: dish, food: food) do |di|
      di.amount_g = ingredient[:amount_g]
    end
  end
end
