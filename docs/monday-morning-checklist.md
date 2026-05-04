# 来週月曜朝 チェックリスト

## 実行前確認

1. NAS マウント
   sudo mount -t cifs //192.168.10.10/share /mnt/nas -o guest
   ls -la /mnt/nas/eiyoso/ | wc -l

2. PostgreSQL 起動
   sudo systemctl status postgresql

3. プロジェクトフォルダ
   cd ~/projects/eiyoukensaku_app

## 実行フロー

1. rails db:drop db:create db:migrate
2. bundle exec rake import:foods_phase1_2a
3. rails console
   Food.count
   FoodComponent.count

## 完了！
