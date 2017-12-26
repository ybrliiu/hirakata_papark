# ひらかたパパーク サーバーサイド 設計

# 概要
Perlで作成  
OOP : Mouse  
Argments validator : experimental::signatures & Smart::Args  
WAF : Mojolicious  
DB  : Postgresql  
ORM : Aniki  
Migration tool : Anego  
DIコンテナ: Bread::Board -> Object::Container(移行中)  

# モジュール構造

# URL設計

# データベース設計
HirakataPapark::DB::Schema を参照

# コードの書き方についての規約
* 関数呼び出しおよびメソッド呼び出しにおいて, ()が不要な場合は記述しない。  
* 関数の最後で値を返却するときは return を書かない。  
* undefを返す可能性のあるメソッドは基本的にoptionでラップして返す  
  * Optionはこのプロジェクトで独自に使用している未定義値を含む場合のある値を扱うオブジェクトで,ScalaのOption型を参考に実装している。HaskellにおけるMaybeモナド,JavaにおけるOptional型などと同じようなもの
* メソッドを実行した結果の成功、失敗はできるだけEitherで表現する。  
  * Eitherはこのプロジェクトで独自に使用している成功、失敗といった結果を値として扱うオブジェクトで、ScalaのEither型を参考に実装している。Haskellにも同様のものがあり、他にRustのResult型などと同じようなもの
* もし例外を投げる場合はHirakataPapark::Exceptionもしくはそれを継承したクラスで例外を投げる。ただしContollerは別で,dieして後のエラー表示はMojoliciousに任せる  

# Model層規約
* Rowオブジェクトのリストを返却する場合はModel::Resultもしくはそれを継承したクラスでラップして返す  

# Contoller層規約
* パラメータを受け取るときはスネークケースで受け取る  
* JSONを返す時はスネークケースで返却する  
* 例外を投げる場合はdieして後のエラー処理はMojoliciousに任せる  
