# ひらかたパパーク

## 予定

### ユーザー登録機能
* ユーザー登録機能追加
  * ログインしているユーザーは以下のことが可能
    * 名前付きのコメント
    * タグ付け
    * 公園情報の編集
    * 公園の追加
    * 公園の画像投稿
* SNSとの連携ログイン
  * facebook, twitterのアカウントをもっている人はそのアカウントのIDでログイン可能

### リファクタリング関係
* templateの改善(処理のまとめ方とか)
* コーデイングスタイルの統一(命名規則)
  * 引数なしのメソッド呼び出しは()つけない
  * 関数の最後のreturnは必要ないなら書かない
  * サブルーチンシグネチャを使えるところでは使う
* 他言語対応, よりよい形を考案する

### テスト関係
* 書いていないテストを書く
* コンテナを使ってテストによく使うインスタンスを使いまわす

### デザイン関係
* favicon.ico 設定
* レイアウト, UIの改善

* 検索ページの作成中
  * 全ての条件を複合的に合わせて調べるページも作る

### その他
* 公園コメント機能追加中
  - reloadボタン
  - 返信機能
* 公園ページ 周辺施設 詳細表示

## 問題点
* 公園の読みや住所のよみがわからないので、英語表記も正確に出来ない,できればデータほしい
* 英語の翻訳が不正確だと思う
* 淀川河川公園とか枚方市管轄外の公園がデータにないみたい

## 環境構築について
* carton install -> Perl の依存モジュールインストール
* etc/config/db.conf にデータベースの設定を書く
* author/excel_to_db.pl (公園データDB登録)
* author/equipment_to_db.pl (公園施設データDB登録)

