# ひらかたパパーク

## 予定

* 画像投稿機能作成中

  * [仕様]
  * public/park_images/$park_id/$sha1_sum で保存
  * 画像情報はDBに格納して管理, Modelで画像ファイルとの整合性をとる
  * 投稿可能な画像形式はpng, jpg, gif
  * schema park_id, filename_without_extension: Str, filename_extension: Str, park_id & filename_without_extension: pkey

  * [予定]
  * 画像投稿service作成
  * Contoller記述
  * クライアント側記述, 画像はvue-imageで表示, 画像投稿画面作成

* ユーザーができる機能
  * 公園の画像投稿
  * 名前付きのコメント
  * 公園情報の編集
  * 公園の追加
* Model::get_row SQLの型が違うときに例外がでるのはどう対処する
* render_unauthorized (401 Unauthorized)
* ひらかたパパークのログイン機能をoauth2で実装することを検討する
* SNSとの連携ログイン
  * facebook, アカウントをもっている人はそのアカウントのIDでログイン可能
* マイページ作成
  * ユーザーデー多編集
  * 公園の編集履歴など
* 公園検索機能にお気に入り数順を入れる
* 公園コメント機能追加中
  - reloadボタン
  - 返信機能
* 公園ページ 周辺施設 詳細表示
* タグ機能, ニコ動のタグ機能を参考に機能を強化する

### バグ
* 現在地周辺検索, 現在地の取得が上手くいかなかった場合, undefが渡されてバグることがある

### デザイン関係
* favicon.ico 設定
* レイアウト, UIの改善(マテリアルデザインの勉強?)
* 検索ページの作成中
  * 全ての条件を複合的に合わせて調べるページも作る

### リファクタリング関係
* コーデイングスタイルの統一(命名規則)
  * 引数なしのメソッド呼び出しは()つけない
  * 関数の最後のreturnは必要ないなら書かない
  * サブルーチンシグネチャを使えるところでは使う
* Contoller->param をoptionでらっぷするぞ...
* Model add_row throw exception ではなくEither返却?
* Web.pm sessionの設定
* sessionで使うkeyって定数にしたほうがいい気がする
* JSのコードりふぁくたりんぐ, mixinを使っていく
* テンプレートをlang_dictで共通化させて,ファイル数を削減する

#### 一貫性の崩れ
* Model get_row_* unique制約によってrowを一個だけとってこれるパターンが決まっているならget_rowに省略してしまう[非整合]
* lang_dict length_func

### テスト関係
* 書いていないテストを書く
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
  * windowsで文字化けする場合や書き込み時にwide charactor ~ でエラーが出る場合, { pg_enable_utf8 => 1 } オプションを追加,  
    取得してきたデータをエンコードするとよい(そもそもubuntuでもするべきなのか?)
* etc/config/hypnotoad.conf にhypnotoadサーバの設定を書く(デフォか他の鯖使うなら空でもよい)
* etc/config/plugin.conf にMojolicious pluginの設定を書く
* etc/config/twitter.conf にtwitter appの設定を書く(consumer_key, consumer_seacret)
* anego migrate
* author/park_csv_to_db.pl -> DBにデータ流し込む
* npm run build-dev -> bundle.js 生成

