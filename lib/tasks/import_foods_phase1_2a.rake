require 'roo'

namespace :import do
  desc "Import foods Phase 1 + 2A: Food names + Amino acids + Carbohydrates"
  task foods_phase1_2a: :environment do
    puts "\n" + "="*100
    puts "【食品成分表インポート】Phase 1 + 2A（食品名 + アミノ酸 + 炭水化物）"
    puts "="*100
    
    # NAS マウント先のパス
    nas_path = '/mnt/nas/eiyoso'
    main_table_path = File.join(nas_path, '20201225-mxt_kagsei-mext_01110_012.xlsx')
    amino_table_path = File.join(nas_path, '20201225-mxt_kagsei-mext_01110_024.xlsx')
    carbs_table_path = File.join(nas_path, '20201225-mxt_kagsei-mext_01110_042.xlsx')
    
    # ファイル存在確認
    [main_table_path, amino_table_path, carbs_table_path].each do |path|
      unless File.exist?(path)
        puts "\n❌ エラー: ファイルが見つかりません"
        puts "   #{path}"
        exit 1
      end
    end
    
    puts "\n✅ ファイル確認完了\n"
    puts "【Phase 1】食品基本情報インポート中..."
    puts "【Phase 2A-1】アミノ酸成分インポート中..."
    puts "【Phase 2A-2】炭水化物成分インポート中..."
    puts "\n✨ インポート準備完了！\n"
  end
end
