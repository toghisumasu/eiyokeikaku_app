# Rails 環境構築トラブルシューティング記録
## eiyoukensaku_app プロジェクト セットアップ学習ドキュメント

**作成日**: 2026年4月15日  
**プロジェクト**: eiyoukensaku_app（Rails 7）  
**環境**: WSL2/Debian、PostgreSQL 15  
**目的**: バージョン競合・環境問題の発見方法と対応を記録・学習

---

## Issue 1: Tailwind CSS Gem ダウンロード失敗

### 症状
```
Bundler::HTTPError: Could not download gem from https://rubygems.org/ 
due to underlying error <bad response Forbidden 403>
  tailwindcss-ruby-4.2.2-x86_64-linux.gem
```

### 原因分析
```
・Rails 8 デフォルトで tailwindcss-rails が含まれている
・tailwindcss-ruby gem の特定バージョンが rubygems.org から DL 不可
・バイナリ gem の配布制限（国・リージョン制限の可能性）
```

### 解決方法
```bash
# 方法1: Tailwind CSS を外す（推奨）
cat Gemfile | grep -v tailwindcss-rails > Gemfile.tmp
mv Gemfile.tmp Gemfile
bundle install

# 方法2: Tailwind CSS なしで Rails 作成
rails new project_name --database=postgresql --skip-css
```

### 学習ポイント
```
✅ エラーメッセージから「どの gem が失敗したか」を特定
✅ 新規 Rails プロジェクト時に不要な機能は --skip-* で除外
✅ Ruby/Rails のバージョン互換性を事前確認
```

---

## Issue 2: error_highlight Gem バージョン競合

### 症状
```
Gem::LoadError: You have already activated error_highlight 0.3.0, 
but your Gemfile requires error_highlight 0.7.0. 
Since error_highlight is a default gem, you can either remove your 
dependency on it...
```

### 原因分析
```
・システム Ruby 3.1 に error_highlight 0.3.0 がバンドルされている
・Rails 7.2 が error_highlight 0.7.0 を Gemfile に明示している
・Default gem（Ruby に組み込み）を Gemfile で重複指定する問題
```

### 解決方法
```bash
# Gemfile から error_highlight を削除
sed -i '/error_highlight/d' Gemfile

# Gemfile.lock リセット
rm Gemfile.lock

# 再インストール
bundle install
```

### 詳細な確認方法
```bash
# Gemfile 内で問題の行を検索
grep -n error_highlight Gemfile

# Default gem か確認
ruby -e "puts Gem.loaded_specs['error_highlight']&.version"

# システム Gem と vendor/bundle の競合確認
bundle show error_highlight
```

### 学習ポイント
```
✅ Default gem（Ruby に付属）の特別な扱い
✅ Gemfile.lock のリセット時機
✅ Ruby バージョンと Gem 互換性の関係
✅ 「既にアクティブ化」エラーの読み取り方
```

---

## Issue 3: PostgreSQL ロール（ユーザー）不在

### 症状
```
PG::ConnectionBad: connection to server on socket 
"/var/run/postgresql/.s.PGSQL.5432" failed: 
FATAL:  role "shinobuccio" does not exist
```

### 原因分析
```
・PostgreSQL インストール時、OS ユーザー名に対応する DB ロールが作成されていない
・Rails は config/database.yml で username: shinobuccio を指定しているが、
  PostgreSQL 側に該当ロールがない
```

### 解決方法
```bash
# 1. PostgreSQL 起動確認
sudo systemctl start postgresql
sudo systemctl status postgresql

# 2. postgres ユーザーで PostgreSQL コンソール接続
sudo -u postgres psql

# PostgreSQL コンソール内:
postgres=# CREATE ROLE shinobuccio WITH LOGIN CREATEDB;
postgres=# ALTER ROLE shinobuccio WITH PASSWORD '<your_password>';
postgres=# \q

# 3. ロール作成確認
psql -U shinobuccio -d postgres -c "SELECT 1"
```

### 詳細な確認・管理コマンド
```bash
# PostgreSQL ロール一覧確認（postgres ユーザーで）
sudo -u postgres psql -c "\du"

# ロール属性の詳細確認
sudo -u postgres psql -c "\du shinobuccio"

# ロールの削除（やり直す場合）
sudo -u postgres psql -c "DROP ROLE shinobuccio;"

# DB の削除（やり直す場合）
rails db:drop
rails db:create db:migrate
```

### database.yml での対応例
```yaml
development:
  adapter: postgresql
  database: eiyoukensaku_app_development
  username: shinobuccio           # ← PostgreSQL ロール名
  password: <your_password>              # ← 上記で設定したパスワード
  host: localhost
  port: 5432
```

### 学習ポイント
```
✅ OS ユーザー ≠ PostgreSQL ロール（混同しやすい）
✅ PostgreSQL ロール管理の基本（CREATE/DROP/ALTER）
✅ database.yml と PostgreSQL 設定の対応関係
✅ 権限エラーの読み取り方（FATAL vs WARNING）
```

---

## Issue 4: NAS ファイル アクセス（WSL2）

### 症状
```
複数の Rails ファイル（計 20MB+）を NAS に保存
WSL2 から直接アクセスしたい
```

### 原因分析
```
・Windows のネットワークドライブマッピング（Z: など）は
  WSL2 からは見えない
・WSL2 から NAS に直接マウントする必要がある
```

### 解決方法
```bash
# 1. cifs-utils インストール
sudo apt-get update
sudo apt-get install cifs-utils

# 2. マウントポイント作成
sudo mkdir -p /mnt/nas

# 3. NAS をマウント（ゲストアクセス）
sudo mount -t cifs //<NAS_HOST>/share /mnt/nas -o guest

# 4. マウント確認
ls -la /mnt/nas/eiyoso/

# 5. Rake タスク内でパスを指定
nas_path = '/mnt/nas/eiyoso'
main_table_path = File.join(nas_path, '20201225-mxt_kagsei-mext_01110_012.xlsx')
```

### 自動マウント設定（fstab）
```bash
# /etc/fstab に以下を追加（永続化）
sudo tee -a /etc/fstab > /dev/null <<EOF
//<NAS_HOST>/share /mnt/nas cifs guest,uid=1000,gid=1000,file_mode=0755,dir_mode=0755 0 0
EOF

# マウント確認
sudo mount -a
```

### 学習ポイント
```
✅ WSL2 の Linux サブシステムと Windows ホストの相違
✅ cifs プロトコルによるネットワークマウント
✅ ゲストアクセス vs ユーザー認証の使い分け
✅ Rake タスク内でのファイルパス指定方法
```

---

## 総合学習マトリックス

| Issue | 検出方法 | 原因の種類 | 解決レベル | 実務度 |
|:---|:---|:---|:---:|:---:|
| Tailwind CSS DL失敗 | Bundler エラー | ネットワーク/互換性 | Gem 管理 | ⭐⭐⭐ |
| error_highlight 競合 | Runtime LoadError | バージョン管理 | 環境設定 | ⭐⭐⭐⭐ |
| PostgreSQL ロール不在 | Connection Failed | DB 権限設定 | インフラ | ⭐⭐⭐⭐⭐ |
| NAS ファイルアクセス | File Not Found | ネットワーク設定 | ネットワーク | ⭐⭐⭐ |

---

## エラー検出フロー図

```
【エラーが発生した時の対応フロー】

1. エラーメッセージを全文読む
   ↓
2. 「FATAL / ERROR / WARNING」のレベルを判定
   ↓
3. スタックトレース（一番下）から原因箇所を特定
   ↓
4. 以下のいずれかを確認：
   ├─ Gem バージョン競合 → Gemfile.lock リセット
   ├─ DB 権限エラー    → PostgreSQL ロール確認
   ├─ ファイルパス     → File existence check
   ├─ ネットワーク     → Connection / mount 確認
   └─ システムコマンド  → systemctl status / service
   ↓
5. 原因に応じた対応実施
   ↓
6. 同じエラーが出ないか確認（コマンド再実行）
   ↓
7. このドキュメントに追記（次の学習へ）
```

---

## 来週月曜朝の準備チェックリスト

```
準備項目:
☐ NAS マウント確認: ls -la /mnt/nas/eiyoso/
☐ PostgreSQL 起動: sudo systemctl status postgresql
☐ Rake タスク配置: ls -lh lib/tasks/import_foods_phase1_2a.rake
☐ DB 確認: rails db:version
☐ Bundle 確認: bundle list | grep roo

実行フロー:
☐ rails db:drop db:create db:migrate
☐ bundle exec rake import:foods_phase1_2a
☐ rails console で Food.count / FoodComponent.count 確認
```

---

## 参考リンク・コマンド集

```bash
【Bundler / Gem 管理】
bundle show GEM_NAME              # Gem の場所確認
bundle list                        # インストール済み Gem 一覧
bundle install --verbose          # 詳細ログ付きインストール
rm Gemfile.lock                    # lock ファイルリセット

【PostgreSQL 管理】
sudo systemctl status postgresql   # PostgreSQL 状態確認
sudo -u postgres psql              # postgres で接続
\du                               # ロール一覧
\l                                # DB 一覧
CREATE ROLE user WITH LOGIN;      # ロール作成

【WSL2 / ネットワーク】
mount | grep nas                  # マウント確認
df -h                             # ディスク使用状況
lsblk                             # ブロックデバイス確認
ping <NAS_HOST>                # NAS 疎通確認（WSL2 限界）

【Rails / DB】
rails db:create db:migrate        # DB 作成・マイグレーション
rails console                     # Rails コンソール
rails --version                   # Rails バージョン確認
```

---

## 最後に

このドキュメントは **実務で起こる問題を解決した記録** です。

同じエラーに遭遇したら、このドキュメントを検索して、**同じ手順で解決** できます。

また、新しいエラーが発生したら、**このドキュメントに追記** して、ナレッジを蓄積していってください。

**「エラーは学習機会」という姿勢が、エンジニアを成長させます。** 🚀
