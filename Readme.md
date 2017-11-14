# ひらかたパパーク

## 予定

* 内部の改善, service, controller関連
* Point -> Coord latitude longtude
* extend Row::Park class
* Model::Praks::to_json_for_marker
* DB::Result
* templateの改善(処理のまとめ方とか)
* コーデイングスタイルの統一(命名規則, returnの有無, シグネチャの有無)

* favicon.ico 設定

* 検索ページの作成中
  * 全ての条件を複合的に合わせて調べるページも作る

* ユーザー登録機能追加
  * ログインしているユーザーは、
    * 名前付きのコメント
    * タグ付け
    * 公園情報の編集
    * 公園の追加
    * 公園の画像投稿
  ができる
* SNSとの連携ログイン
  * facebook, twitterのアカウントをもっている人はそのアカウントのIDでログイン可能
* 公園コメント機能追加中
  - reloadボタン
  - 返信機能
* 公園ページ 周辺施設 詳細表示
* レイアウト, UIの改善

## 問題点
* 公園の読みや住所のよみがわからないので、英語表記も正確に出来ない,できればデータほしい
* 英語の翻訳が不正確だと思う
* 淀川河川公園とか枚方市管轄外の公園がデータにないみたい

## 環境構築について
* carton install -> Perl の依存モジュールインストール
* etc/config/db.conf にデータベースの設定を書く
* author/excel_to_db.pl (公園データDB登録)
* author/equipment_to_db.pl (公園施設データDB登録)

