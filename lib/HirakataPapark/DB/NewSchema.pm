package HirakataPapark::DB::Schema {

  use HirakataPapark;
  use DBIx::Schema::DSL;
  use Aniki::Schema::Relationship::Declare;

  database 'PostgreSQL';

  default_not_null;

  # 1つのデータに多言語の項目のデータが1つの時は '言語コード名_カラム名' で項目を追加していく
  # 2つ以上の時は別のテーブルに分ける
 
  create_table equipment => columns {
    string id => primary_key;
    integer 'recommended_age' => (default => 0);
    string 'ja_name';
    string 'en_name';
  };

  create_table surrounding_facility => columns {
    string id => primary_key;
    string 'ja_name';
    string 'en_name';
  };

  create_table plant => columns {
    string id => primary_key;
    string 'order';   # 目
    string 'family';  # 科
    string 'genus';   # 属
    string 'species'; # 種
  };

  create_table en_plant => columns {
    string id => primary_key;
    string 'order';
    string 'family';
    string 'genus';
    string 'species';
    foreign_key id => (plant => 'id');
  };

  create_table park => columns {
    integer 'id' => (primary_key, auto_increment);
    string 'name';
    string 'zipcode';
    string 'address';
    string 'explain' => (default => '');
    double 'x';
    double 'y';
    double 'area';
    smallint 'is_locked'          => (default => 0);
    smallint 'is_evacuation_area' => (default => 0);

    add_unique_index 'park_name_unique' => ['name'];
    add_index 'park_name_index' => ['name'];
  };

  create_table en_park => columns {
    integer 'id' => primary_key;
    string 'name';
    string 'address';
    string 'explain' => (default => '');

    # SQL::Translator のunique制約へのCONSTRAINT自動命名がクソ(カラム名 + '_unque')
    # で容易に多テーブルと衝突してしまうので, ここで直接命名
    add_unique_index 'en_park_name_unique' => ['name'];
    foreign_key id => (park => 'id');
  };

  # 設備1つずつのデータを記録することも考えたけど今は必要なさそう
  create_table park_equipment => columns {
    integer 'id' => (primary_key, auto_increment);
    integer 'park_id';
    string 'equipment_id';
    integer 'num' => (default => 1);
    string 'comment';

    add_unique_index 'park_equipment_unique' => ['park_id', 'equipment_id'];
    foreign_key park_id      => (park      => 'id');
    foreign_key equipment_id => (equipment => 'id');
  };

  create_table park_surrounding_facility => columns {
    integer 'id' => (primary_key, auto_increment);
    integer 'park_id';
    string 'surrounding_facility_id';
    string 'comment';

    add_unique_index 'park_surrounding_facility_unique' => ['park_id', 'surrounding_facility_id'];
    foreign_key park_id => (park => 'id');
    foreign_key surrounding_facility_id => (surrounding_facility => 'id');
  };

  create_table park_plant => columns {
    integer 'id' => (primary_key, auto_increment);
    integer 'park_id';
    string 'plant_id';
    string 'comment';
    integer 'num' => ( default => 1 );

    add_unique_index 'park_plants_unique' => ['park_id', 'name'];
    foreign_key park_id  => (park  => 'id');
    foreign_key plant_id => (plant => 'id');
  };

  create_table park_tag => columns {
    integer 'park_id';
    string 'name';

    set_primary_key qw( park_id name );
    foreign_key park_id => (park => 'id');
  };

  create_table park_event => columns {
    integer 'id' => (primary_key, auto_increment);
    integer 'park_id';
    string 'title';
    text 'explain';

    foreign_key park_id => (park => 'id');
  };

  create_table park_comment => columns {
    integer 'park_id';
    integer 'id' => (primary_key, auto_increment);
    string 'name';
    bigint 'time';
    text 'message';

    foreign_key park_id => (park => 'id');
  };

  create_table park_news => columns {
    integer 'park_id';
    integer 'id' => (primary_key, auto_increment);
    string 'title';
    text 'message';

    foreign_key park_id => (park => 'id');
  };

  create_table user => columns {
    integer 'seacret_id' => (primary_key, auto_increment);
    string 'id';
    string 'name';
    string 'password';

    string 'address' => (default => '');
    string 'profile' => (default => '');
    string 'twitter_id'  => null;
    string 'facebook_id' => null;

    smallint 'can_edit_park' => (default => 1);

    # SQL::Translator のunique制約へのCONSTRAINT自動命名がクソ(カラム名 + '_unque')
    # で容易に多テーブルと衝突してしまうので, ここで直接命名
    add_unique_index 'user_id_unique'          => ['id'];
    add_unique_index 'user_name_unique'        => ['name'];
    add_unique_index 'user_twitter_id_unique'  => ['twitter_id'];
    add_unique_index 'user_facebook_id_unique' => ['facebook_id'];
  };

  create_table park_star => columns {
    integer 'park_id';
    integer 'user_seacret_id';

    add_unique_index 'park_star_unique' => ['park_id', 'user_seacret_id'];
    foreign_key park_id         => (park => 'id');
    foreign_key user_seacret_id => (user => 'seacret_id');
  };

  create_table park_image => columns {
    integer 'park_id';
    integer 'posted_user_seacret_id';
    string 'title';
    string 'filename_without_extension';
    string 'filename_extension';
    bigint 'posted_time';

    add_unique_index 'park_image_unique' => ['park_id', 'filename_without_extension'];
    foreign_key park_id                => (park => 'id');
    foreign_key posted_user_seacret_id => (user => 'seacret_id');
  };

  create_table users_park_edit_history => columns {
    integer 'id' => (primary_key, auto_increment);
    integer 'park_id';
    integer 'editer_seacret_id';
    bigint 'edited_time';

    string 'park_name';
    string 'park_zipcode';
    string 'park_address';
    string 'park_explain';
    double 'park_x';
    double 'park_y';
    double 'park_area';
    smallint 'park_is_evacuation_area';

    foreign_key park_id           => (park => 'id');
    foreign_key editer_seacret_id => (user => 'seacret_id');
  };

  create_table users_en_park_edit_history => columns {
    integer 'history_id' => primary_key;
    string 'park_name';
    string 'park_address';
    string 'park_explain';

    foreign_key history_id => (users_park_edit_history => 'id');
  };

  create_table users_park_plant_edit_history => columns {
    integer 'id' => (primary_key, auto_increment);
    integer 'park_id';
    integer 'editer_seacret_id';
    bigint 'edited_time';

    foreign_key park_id           => (park => 'id');
    foreign_key editer_seacret_id => (user => 'seacret_id');
  };

  create_table users_park_plant_edit_history_row => columns {
    integer 'id' => (primary_key, auto_increment);
    integer 'history_id';
    string 'plant_id';
    string 'plant_comment';
    integer 'plant_num';

    add_unique_index users_park_plant_edit_history_row_unique =>
      [qw( history_id plant_id )];
    foreign_key history_id => (users_park_plant_edit_history => 'id');
  };

  create_table users_park_equipment_edit_history => columns {
    integer 'id' => (primary_key, auto_increment);
    integer 'park_id';
    integer 'editer_seacret_id';
    bigint 'edited_time';

    foreign_key park_id           => (park => 'id');
    foreign_key editer_seacret_id => (user => 'seacret_id');
  };

  create_table users_park_equipment_edit_history_row => columns {
    integer 'id' => (primary_key, auto_increment);
    integer 'history_id';
    string 'equipment_id';
    string 'equipment_comment';
    integer 'equipment_num';

    add_unique_index 'users_park_equipment_edit_history_row_unique' =>
      [qw( history_id equipment_id )];
    foreign_key history_id => (users_park_equipment_edit_history => 'id');
  };

  create_table users_park_surrounding_facility_edit_history => columns {
    integer 'id' => (primary_key, auto_increment);
    integer 'park_id';
    integer 'editer_seacret_id';
    bigint 'edited_time';

    foreign_key park_id           => (park => 'id');
    foreign_key editer_seacret_id => (user => 'seacret_id');
  };

  create_table users_park_surrounding_facility_edit_history_row => columns {
    integer 'id' => (primary_key, auto_increment);
    integer 'history_id';
    string 'surrounding_facility_id';
    string 'surrounding_facility_comment';

    add_unique_index users_park_surrounding_facility_edit_history_row_unique =>
      [qw( history_id surrounding_facility_id )];
    foreign_key history_id => (users_park_surrounding_facility_edit_history => 'id');
  };

}

1;
