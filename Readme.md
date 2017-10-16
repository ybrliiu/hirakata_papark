# ひらかたパパーク

## 予定

* 検索ページの作成中
  * 植物
  * タグ
  * 全ての条件を複合的に合わせて調べるページも作る

* Model::Parks get_rows_has_equipments_names などはservice側で定義すべき, renameも考慮

* 英語のデータを作る
* 桜の木は別ページで表示
* 公園コメント機能追加中
  - reloadボタン
  - 返信機能
* 公園の画像投稿機能
* 現在地周辺の公園 徒歩10分(約800m以内)の公園はリストアップ&マップ表示
* SNSとの連携

* 周辺検索はフォームの値で切り替えても良いかも
* /search/* get -> post

## 問題点
* 淀川河川公園とか枚方市管轄外の公園がデータにないみたい

## 環境構築について
* carton install -> Perl の依存モジュールインストール
* etc/config/db.conf にデータベースの設定を書く
* author/excel_to_db.pl (公園データDB登録)
* author/equipment_to_db.pl (公園施設データDB登録)

