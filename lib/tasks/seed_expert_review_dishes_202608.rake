# 出典: 和知学校給食センター発行 2026年6月献立表（PDF）より、料理名と食材構成のみを抽出。
# 分量・栄養価・解説文は含まない。standard_amountは全て仮値0.0g（専門家評価時に実測値へ差し替え予定）。
namespace :seed do
  task expert_review_dishes_202608: :environment do
    dishes_data = [
      {
        name: "とりにくのマスタードやき",
        category: "主菜",
        food_ids: [4440, 4384, 2864, 2855, 4872, 2627, 2736, 3205, 3127, 3031, 3227]
      },
      {
        name: "にくどうふ",
        category: "主菜",
        food_ids: [4272, 2855, 2627, 2758, 3127, 3205, 3125, 2967, 3026]
      },
      {
        name: "チャプチェ",
        category: "主菜",
        food_ids: [4440, 4272, 3641, 4320, 2627, 2769, 2929, 4500, 3553, 3248, 3250, 3125, 3205, 3127, 3312]
      },
      {
        name: "さばのみそに",
        category: "主菜",
        food_ids: [3835, 4872, 4384, 2855, 2627, 2775, 3127, 3205, 3227]
      },
      {
        name: "かいそうサラダ",
        category: "副菜",
        food_ids: [3641, 2775, 3026, 3031, 3540]
      },
      {
        name: "ちくわのいそべあげ",
        category: "副菜",
        food_ids: [4097, 3596, 3598, 2864, 3641, 4872, 2627, 2513, 4505, 2775, 2736, 3049, 3026, 3205, 3563, 3227]
      }
    ]

    notes = "分量未入力・要実測値"

    dishes_data.each do |data|
      dish = Dish.find_or_create_by!(name: data[:name]) do |d|
        d.category = data[:category]
        d.notes = notes
      end
      dish.update!(category: data[:category], notes: notes)

      data[:food_ids].each do |food_id|
        DishIngredient.find_or_create_by!(dish: dish, food_id: food_id) do |di|
          di.amount_g = 0.0
        end
      end

      puts "#{dish.name}: #{dish.dish_ingredients.count}件の食品明細"
    end
  end
end
