# ひらかたパパーク

## 予定

* 内部の改善, service, controller関連
* templateの改善(処理のまとめ方とか)
* コーデイングスタイルの統一(命名規則, returnの有無, シグネチャの有無)

* 現在地周辺の公園 徒歩10分(約800m以内)の公園はリストアップ&マップ表示

* 公園ページ 周辺施設の表示

* 検索ページの作成中
  * 全ての条件を複合的に合わせて調べるページも作る

* SNSとの連携やユーザー登録について考える
* SNSとの連携
* 公園コメント機能追加中
  - reloadボタン
  - 返信機能

* 公園の画像投稿機能
* タグ付け機能
* 公園編集機能

* 周辺検索はフォームの値で切り替えても良いかも

## 問題点
* 公園の読みや住所のよみがわからないので、英語表記も正確に出来ない,できればデータほしい
* 英語の翻訳が不正確だと思う
* 淀川河川公園とか枚方市管轄外の公園がデータにないみたい

## 環境構築について
* carton install -> Perl の依存モジュールインストール
* etc/config/db.conf にデータベースの設定を書く
* author/excel_to_db.pl (公園データDB登録)
* author/equipment_to_db.pl (公園施設データDB登録)

