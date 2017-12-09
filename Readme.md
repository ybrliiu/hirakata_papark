# ひらかたパパーク

## 予定

### ユーザー登録機能
* いい加減辞書を作ってtemplateで使って方がよくないか
* クライアント-サーバー間のJSONのやり取りについて考える
  * キーのキャメルケース, スネークケースの差異による問題とか
  * クライアント側に寄せたほうが(スネークケース)JSの処理をまとめやすくて良い?
    * あるいは変換するメソッド使うとか
* Object::Container使う
* Contollerに$self->dbを追加
* ExceptionとValidatorに共通のインタフェースかぶせたら幸せになるかも
* render_unauthorized (401 Unauthorized)
* render_exception
* ユーザー登録機能追加
  * ログインしているユーザーは以下のことが可能
    * 公園情報の編集
    * 公園の画像投稿
    * 名前付きのコメント
    * 公園の追加
* ひらかたパパークのログイン機能をoauth2で実装することを検討する
* SNSとの連携ログイン
  * facebook, twitterのアカウントをもっている人はそのアカウントのIDでログイン可能
* マイページ作成
  * ユーザーデー多編集
  * 公園の編集履歴など
  * お気に入りの公園一覧
* 公園検索機能にお気に入り数順を入れる
* 公園コメント機能追加中
  - reloadボタン
  - 返信機能
* 公園ページ 周辺施設 詳細表示

### デザイン関係
* favicon.ico 設定
* レイアウト, UIの改善(マテリアルデザインの勉強?)
* 検索ページの作成中
  * 全ての条件を複合的に合わせて調べるページも作る

### リファクタリング関係
* templateの改善
  テンプレートの言語別表示は設定ファイルにデータ持たせて$langの値で切り替えて良いのでは?
  テンプレートの構成も単純になってわかりやすい
  その上でまとめきれていないところはまとめる
* コーデイングスタイルの統一(命名規則)
  * 引数なしのメソッド呼び出しは()つけない
  * 関数の最後のreturnは必要ないなら書かない
  * サブルーチンシグネチャを使えるところでは使う
* キャッシュできるところはキャッシュしていく, 
  キャッシュが増えすぎてわかりにくくなると思ったらBread::Board or Object::Container使う
* Contoller->param をoptionでらっぷするぞ...
* Model add_row throw exception ではなくEither返却
* Web.pm のrender_error上書きの書き直し
* Web.pm sessionの設定

### テスト関係
* 書いていないテストを書く
* コンテナを使ってテストによく使うインスタンスを使いまわす
* Test2でテスト書く

## 問題点
* 公園の読みや住所のよみがわからないので、英語表記も正確に出来ない,できればデータほしい
* 英語の翻訳が不正確だと思う
* 淀川河川公園とか枚方市管轄外の公園がデータにないみたい

## 環境構築について

### やりたいこと
* js ES2015&babel使う?

### 前提
* plenv, cpanm, carton のインストール(Perlモジュール関係)
* ndenv, npm のインストール(JavaScript, CSSモジュール関係)
* nginxなどサーバーのたちあげ、設定
* postgresqlインストール&設定
* install.sh でplenv, ndenvあたりインストールした後, あとはDaikufileかnpm scriptsで管理すると良さそう

### その後
* carton install --development
* npm install
* etc/config/db.conf にデータベースの設定を書く
* etc/config/plugin.conf にMojolicious pluginの設定を書く(デフォの設定作ってしまって良さそう)
* anego migrate
* author/park_csv_to_db.pl -> DBにデータ流し込む
* npm run build-dev -> bundle.js 生成

