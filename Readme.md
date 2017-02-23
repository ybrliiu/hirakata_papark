# ひらかたパパーク

## 予定
* 公園コメント機能追加中
  - reloadボタン, 投稿時リロード
  - 色, デザイン変更
  - 返信機能
* 位置情報の扱いを確実に
* 各公園の住所を格納(Google APIで)

* メニューボタンはわかりやすくしたい
* 周辺検索はフォームの値で切り替えても良いかも
* /search/* get -> post
* about 書く

## 環境構築について
* carton install -> Perl の依存モジュールインストール
* etc/config/db.conf にデータベースの設定を書く
* author/excel_to_db.pl (公園データDB登録)
* author/equipment_to_db.pl (公園施設データDB登録)

