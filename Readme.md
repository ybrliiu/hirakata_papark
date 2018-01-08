# ひらかたパパーク

## 予定

* 1/4
* 公園情報の編集
1. Model::Park::EditHistory::Park, Plants, Equipments, SurroundingFacilities作成
  * ResultBuilder作成, get_historiesを実装(クエリの構成にはtest.plが参考になる)
    * items_row table にも主キーが必要なことが判明, それに合わせた変更を行う
      * Meta table root に pkey 追加
      * foreign_lang table に default_lang_table 追加
  * Model::Park::EditHistory::ParkをOneToOneで書き直し, こちらにもBridgeパターンを適用
  * HistoryToAddBuilder, 及び足りない値を補完する部分も作成
1. Modelローダ, コンテナでのインスタンスの共通化
1. Service作成
1. クライアント側作成
1. HirakataPapark::Typesに分割
1. 終わったらスキーマとModel::Role::DBをスキーマの変更に強くする, 
   また, Model::Role::DB, SelectColumnesMaker, Model::Users::ParkEditHistories::Base
   と共通化させるべき部分はくくりだす
1. ForeignLanguage -> ForeignLang

* 1/5
*公園の追加
  * 本体
  * 履歴

* 1/6
* 名前付きのコメント機能

* 1/7
* 管理者機能

* 1/8
* 公園管理者機能

* 1/9
* facebook

* 1/10
* linked open data

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
* 遊具施設詳細表示
* 管理者の機能、公園の管理者向けの機能の実装
* タグ機能, ニコ動のタグ機能を参考に機能を強化する
* linked open data API 作成
* ユーザーデータにメアドも必須にする?

### バグ
* 現在地周辺検索, 現在地の取得が上手くいかなかった場合, undefが渡されてバグることがある

### デザイン関係
* favicon.ico 設定
* デザインの統一性をとる
* レイアウト, UIの改善(マテリアルデザインの勉強, GoogleMapを参考にするのがよさそう)
* トップページとマイページをましなデザインにする

### リファクタリング関係
* コーデイングスタイルの統一(命名規則)
  * 引数なしのメソッド呼び出しは()つけない
  * 関数の最後のreturnは必要ないなら書かない
  * サブルーチンシグネチャを使えるところでは使う
* Contoller->param をoptionでらっぷするぞ...
* Model add_row throw exception ではなくEither返却?
* Web.pm sessionの設定
* sessionで使うkeyって定数にしたほうがいい気がする
* テンプレートをlang_dictで共通化させて,ファイル数を削減する

### テスト関係
* 書いていないテストを書く
* Test2でテスト書く

## 問題点
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

## 依存モジュールへの要望
* vue-images, imagesの要素が0の場合エラー出ますよ
* Mouse, アクセッサとメソッドの名前が同じとき警告かエラー出してくれ
* Mojo::Base::has, アクセッサとメソッドの名前が同じとき警告かエラー出してくれ
* SQL::Traslator ポスグレでunique制約つけた時の名前生成方法を変更してほしい

