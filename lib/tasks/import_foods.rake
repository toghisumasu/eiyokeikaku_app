require 'roo'

namespace :foods do
  desc "食品成分表XLSXをインポートする"
  task import: :environment do
    xlsx_path = '/Volumes/share/eiyoso/20201225-mxt_kagsei-mext_01110_012.xlsx'
    xlsx = Roo::Spreadsheet.open(xlsx_path)
    sheet = xlsx.sheet(0)

    imported = 0
    skipped  = 0

    (13..sheet.last_row).each do |i|
      row = sheet.row(i)

      food_code = row[1]   # index0→index1
      food_name = row[3]   # index2→index3

      next if food_code.nil? || food_name.nil?

      Food.find_or_create_by(food_code: food_code.to_s) do |f|
        f.food_name      = food_name.to_s
        f.energy_kcal    = row[6]
        f.protein_g      = row[9]
        f.fat_g          = row[12]
        f.carbohydrate_g = row[20]
        f.calcium_mg     = row[25]
        f.iron_mg        = row[28]
        f.vitamin_a_ug   = row[42]
        f.vitamin_b1_mg  = row[49]
        f.vitamin_b2_mg  = row[50]
        f.vitamin_c_mg   = row[58]
        f.salt_g         = row[60]
        imported += 1
      end
    end

    puts "インポート完了: #{imported}件 / スキップ: #{skipped}件"
    puts "総レコード数: #{Food.count}"
  end
end
