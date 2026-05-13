namespace :foods do
  NUTRIENTS = %w[
    energy_kcal protein_g fat_g carbohydrate_g
    calcium_mg iron_mg vitamin_c_mg salt_g
  ]

  desc "栄養素ごとの検証用CSVを出力"
  task export_check: :environment do
    require 'csv'
    output_dir = Rails.root.join('tmp', 'nutrient_check')
    FileUtils.mkdir_p(output_dir)

    NUTRIENTS.each do |nutrient|
      path = output_dir.join("#{nutrient}_check.csv")
      CSV.open(path, 'w') do |csv|
        csv << ["食品コード", "食品名", "DB値"]
        Food.order(:food_code).each do |f|
          csv << [f.food_code, f.food_name, f.send(nutrient)]
        end
      end
      puts "出力完了: #{path}"
    end

    puts "---"
    puts "全#{NUTRIENTS.size}ファイル出力完了"
    puts "出力先: #{output_dir}"
  end
end
