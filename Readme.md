# ひらかたパパーク

## 予定

* 英語対応
  * 英語データをスキーマに追加 完了
  * 英語データをCSVに追加 完了
  * 英語データの修正 未完
  * Modelを対応させる(植物, 周辺施設, 遊具, 公園) 完了
  * Model test 対応 完了 完了
  * URLで分ける,言語情報は　:lang で取り込む
  * 言語によってテンプレートを分ける(共通部分を作り, 言語毎にファイルを作成, 引数で言語変更)

* 内部の改善, service関連

* 現在地周辺の公園 徒歩10分(約800m以内)の公園はリストアップ&マップ表示

* 検索ページの作成中
  * 全ての条件を複合的に合わせて調べるページも作る

* SNSとの連携
* 公園コメント機能追加中
  - reloadボタン
  - 返信機能
* 公園の画像投稿機能

* 周辺検索はフォームの値で切り替えても良いかも

## 問題点
* 公園の読みや住所のよみがわからないので、英語表記も正確に出来ない,できればデータほしい
* 淀川河川公園とか枚方市管轄外の公園がデータにないみたい

## 環境構築について
* carton install -> Perl の依存モジュールインストール
* etc/config/db.conf にデータベースの設定を書く
* author/excel_to_db.pl (公園データDB登録)
* author/equipment_to_db.pl (公園施設データDB登録)

