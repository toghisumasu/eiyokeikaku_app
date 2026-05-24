require 'roo'

def parse_nutrient(val)
  return nil if val.nil?
  str = val.to_s.strip
  return nil if str == "" || str == "-"
  return 0.0 if str == "Tr"
  str.gsub(/[()]/, "").to_f
end

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
      food_code = row[1]
      food_name = row[3]
      next if food_code.nil? || food_name.nil?

      Food.find_or_create_by(food_code: food_code.to_s) do |f|
        f.food_name      = food_name.to_s
        f.energy_kcal    = parse_nutrient(row[6])
        f.protein_g      = parse_nutrient(row[9])
        f.fat_g          = parse_nutrient(row[12])
        f.carbohydrate_g = parse_nutrient(row[20])
        f.calcium_mg     = parse_nutrient(row[25])
        f.iron_mg        = parse_nutrient(row[28])
        f.vitamin_a_ug   = parse_nutrient(row[42])
        f.vitamin_b1_mg  = parse_nutrient(row[49])
        f.vitamin_b2_mg  = parse_nutrient(row[50])
        f.vitamin_c_mg   = parse_nutrient(row[58])
        f.salt_g         = parse_nutrient(row[60])
        imported += 1
      end
    end

    puts "インポート完了: #{imported}件 / スキップ: #{skipped}件"
    puts "総レコード数: #{Food.count}"
  end
end
