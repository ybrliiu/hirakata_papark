# ひらかたパパーク サーバーサイド 設計

# 概要
Perlで作成  
OOP : Mouse
Argments validator : Smart::Args
WAF : Mojolicious  
DB  : Postgresql
ORM : Aniki
Migration tool : Anego  

# モジュール構造

# URL設計

# データベース設計
HirakataPapark::DB::Schema を参照

# Model層規約
* RowオブジェクトはModel::Resultもしくはそれを継承したクラスでラップして返す
* undefを返す可能性のあるメソッドはoptionでラップして返す

