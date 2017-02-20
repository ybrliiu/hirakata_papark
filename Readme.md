# ひらかたパパーク

## 予定
* 公園単体のページ
  - コメント
  - 遊具のリスト
* VPSでも動かせるように(proxy, cpanfile, perl version)
* URL設計
* 周辺検索はフォームの値で切り替えても良いかも

## 環境構築について
* carton install -> Perl の依存モジュールインストール
* etc/config/db.conf にデータベースの設定を書く
* author/excel_to_db.pl (公園データDB登録)
* author/equipment_to_db.pl (公園施設データDB登録)

