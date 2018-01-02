# 公園CSVデータについて

枚方市から提供されたデータは書式が揃っていなかったりデータの不備があるため、書式を揃えデータの不備を補った上で最終的にDBに格納する時に使用するCSVデータを生成しています。  
以下にDBに格納する時に使用するCSVデータの生成法を記述します。  

1. convert_to_strict_csv.pl でCSVデータの書式を揃える。
1. get_zipcode.plで郵便番号を補完。
1. 郵便番号を取得できなかった公園を手動で補完。(../data/parks_add_zipcode)
1. 住所がおかしかったので以前DB格納時に使用していたCSVデータ(data/parks_strict_2017_0400.csv)の住所に差し替える。
  このCSVデータの住所データの不足はGoogleMap APIを利用して補完していた。
  できたCSVがdata/marged.csv
1. get_address_how_to_read.plで住所の読みを補完。
1. add_english_data_to_csv.pl で英語名、英語住所のデータを追加する。

DBにデータを格納する時は、park_csv_to_db.plを実行します。  

