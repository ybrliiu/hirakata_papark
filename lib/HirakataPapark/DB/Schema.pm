package HirakataPapark::DB::Schema {

  use HirakataPapark;
  use DBIx::Schema::DSL;
  use Aniki::Schema::Relationship::Declare;

  database 'PostgreSQL';

  default_not_null;

  create_table park => columns {
    integer 'id' => (primary_key, auto_increment);
    string 'name' => (unique);
    string 'zipcode';
    string 'address';
    string 'explain' => (default => '');
    double 'x';
    double 'y';
    double 'area';
    smallint 'is_evacuation_area' => (default => 0);
    smallint 'is_locked' => (default => 0);

    add_index 'park_name_index' => ['name'];
  };

  create_table english_park => columns {
    integer 'id' => (primary_key);
    string 'name'; # => (unique);
    string 'address';
    string 'explain' => (default => '');

    # SQL::Translator のunique制約へのCONSTRAINT自動命名がクソ(カラム名 + '_unque')
    # で容易に多テーブルと衝突してしまうので, ここで直接命名
    add_unique_index 'english_park_name_unique' => ['name'];
    belongs_to park => (
      column    => 'id',
      on_delete => 'CASCADE',
    );
  };

  create_table park_equipment => columns {
    integer 'id' => (primary_key, auto_increment);
    integer 'park_id';
    string 'name';
    string 'comment';
    integer 'recommended_age' => (default => 0);
    integer 'num' => (default => 1);

    add_unique_index 'park_equipment_unique' => ['park_id', 'name'];
    belongs_to park => (
      column    => 'park_id',
      on_delete => 'CASCADE',
    );
  };

  create_table english_park_equipment => columns {
    integer 'id' => (primary_key);
    integer 'park_id';
    string 'name';
    string 'comment';

    add_unique_index 'english_park_equipment_unique' => ['park_id', 'name'];
    belongs_to park_equipment => (
      column    => 'id',
      on_delete => 'CASCADE',
    );
    belongs_to english_park => (
      column    => 'park_id',
      on_delete => 'CASCADE',
    );
  };

  create_table park_surrounding_facility => columns {
    integer 'id' => (primary_key, auto_increment);
    integer 'park_id';
    string 'name';
    string 'comment';

    add_unique_index 'park_surrounding_facility_unique' => ['park_id', 'name'];
    belongs_to park => (
      column    => 'park_id',
      on_delete => 'CASCADE',
    );
  };

  create_table english_park_surrounding_facility => columns {
    integer 'id' => (primary_key);
    integer 'park_id';
    string 'name';
    string 'comment';

    add_unique_index 'english_park_surrounding_facility_unique' =>
      ['park_id', 'name'];
    belongs_to park_surrounding_facility => (
      column    => 'id',
      on_delete => 'CASCADE',
    );
    belongs_to english_park => (
      column    => 'park_id',
      on_delete => 'CASCADE',
    );
  };

  create_table park_plants => columns {
    integer 'id' => (primary_key, auto_increment);
    integer 'park_id';
    string 'name';
    string 'category';
    string 'comment';
    integer 'num' => (default => 1);

    add_unique_index 'park_plants_unique' => ['park_id', 'name'];
    belongs_to park => (
      column    => 'park_id',
      on_delete => 'CASCADE',
    );
  };

  create_table english_park_plants => columns {
    integer 'id' => (primary_key);
    integer 'park_id';
    string 'name';
    string 'category';
    string 'comment';

    add_unique_index 'english_park_plants_unique' => ['park_id', 'name'];
    belongs_to park_plants => (
      column    => 'id',
      on_delete => 'CASCADE',
    );
    belongs_to english_park => (
      column    => 'park_id',
      on_delete => 'CASCADE',
    );
  };

  create_table park_tag => columns {
    integer 'park_id';
    string 'name';

    set_primary_key qw( park_id name );
    belongs_to park => (
      column    => 'park_id',
      on_delete => 'CASCADE',
    );
  };

  create_table park_event => columns {
    integer 'id' => (primary_key, auto_increment);
    integer 'park_id';
    string 'title';
    text 'explain';

    belongs_to park => (
      column    => 'park_id',
      on_delete => 'CASCADE',
    );
  };

  create_table park_comment => columns {
    integer 'park_id';
    integer 'id' => (primary_key, auto_increment);
    string 'name';
    bigint 'time';
    text 'message';

    belongs_to park => (
      column    => 'park_id',
      on_delete => 'CASCADE',
    );
  };

  create_table park_news => columns {
    integer 'park_id';
    integer 'id', (primary_key, auto_increment);
    string 'title';
    text 'message';

    belongs_to park => (
      column    => 'park_id',
      on_delete => 'CASCADE',
    );
  };

  create_table user => columns {
    integer 'seacret_id' => (primary_key, auto_increment);
    string 'id'; # => (unique);
    string 'name'; # => (unique);
    string 'password';

    string 'address' => (default => '');
    string 'profile' => (default => '');
    string 'twitter_id' => (null);
    string 'facebook_id' => (null);

    smallint 'can_edit_park' => (default => 1);

    # SQL::Translator のunique制約へのCONSTRAINT自動命名がクソ(カラム名 + '_unque')
    # で容易に多テーブルと衝突してしまうので, ここで直接命名
    add_unique_index 'user_id_unique' => ['id'];
    add_unique_index 'user_name_unique' => ['name'];
    add_unique_index 'user_twitter_id_unique' => ['twitter_id'];
    add_unique_index 'user_facebook_id_unique' => ['facebook_id'];
    add_index 'user_id_index' => ['id'];
  };

  create_table park_star => columns {
    integer 'park_id';
    integer 'user_seacret_id';

    add_unique_index 'park_star_unique' => ['park_id', 'user_seacret_id'];
    belongs_to park => (
      column    => 'park_id',
      on_delete => 'CASCADE',
    );
    foreign_key user_seacret_id => (
      user      => 'seacret_id',
      on_delete => 'SET NULL',
    );
  };

  create_table park_image => columns {
    integer 'park_id';
    integer 'posted_user_seacret_id';
    string 'title';
    string 'filename_without_extension';
    string 'filename_extension';
    bigint 'posted_time';

    add_unique_index 'park_image_unique' => ['park_id', 'filename_without_extension'];
    belongs_to park => (
      column    => 'park_id',
      on_delete => 'CASCADE',
    );
    foreign_key posted_user_seacret_id => (
      user      => 'seacret_id',
      on_delete => 'SET NULL',
    );
  };

  create_table user_park_edit_history => columns {
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

    belongs_to park => (
      column    => 'park_id',
      on_delete => 'CASCADE',
    );
    foreign_key editer_seacret_id => (
      user      => 'seacret_id',
      on_delete => 'SET NULL',
    );
  };

  create_table user_english_park_edit_history => columns {
    integer 'history_id' => (primary_key);
    string 'park_name';
    string 'park_address';
    string 'park_explain';

    belongs_to user_park_edit_history => (
      column    => 'history_id',
      on_delete => 'CASCADE',
    );
  };

  create_table user_park_plants_edit_history => columns {
    integer 'id' => (primary_key, auto_increment);
    integer 'park_id';
    integer 'editer_seacret_id';
    bigint 'edited_time';

    belongs_to park => (
      column    => 'park_id',
      on_delete => 'CASCADE',
    );
    foreign_key editer_seacret_id => (
      user      => 'seacret_id',
      on_delete => 'SET NULL',
    );
  };

  create_table user_park_plants_edit_history_row => columns {
    integer 'id' => (primary_key, auto_increment);
    integer 'history_id';
    string 'plants_name';
    string 'plants_category';
    string 'plants_comment';
    integer 'plants_num';

    add_unique_index user_park_plants_edit_history_row_unique =>
      [qw( history_id plants_name )];
    belongs_to user_park_plants_edit_history => (
      column    => 'history_id',
      on_delete => 'CASCADE',
    );
  };

  create_table user_english_park_plants_edit_history_row => columns {
    integer 'row_id' => (primary_key, auto_increment);
    integer 'history_id';
    string 'plants_name';
    string 'plants_category';
    string 'plants_comment';

    add_unique_index user_english_park_plants_edit_history_row_unique => 
      [qw( history_id plants_name )];
    belongs_to user_park_plants_edit_history_row => (
      column    => 'row_id',
      on_delete => 'CASCADE',
    );
    belongs_to user_park_plants_edit_history => (
      column    => 'history_id',
      on_delete => 'CASCADE',
    );
  };

  create_table user_park_equipment_edit_history => columns {
    integer 'id' => (primary_key, auto_increment);
    integer 'park_id';
    integer 'editer_seacret_id';
    bigint 'edited_time';

    belongs_to park => (
      column    => 'park_id',
      on_delete => 'CASCADE',
    );
    foreign_key editer_seacret_id => (
      user      => 'seacret_id',
      on_delete => 'SET NULL',
    );
  };

  create_table user_park_equipment_edit_history_row => columns {
    integer 'id' => (primary_key, auto_increment);
    integer 'history_id';
    string 'equipment_name';
    string 'equipment_comment';
    integer 'equipment_recommended_age';
    integer 'equipment_num';

    add_unique_index 'user_park_equipment_edit_history_row_unique' =>
      [qw( history_id equipment_name )];
    belongs_to user_park_equipment_edit_history => (
      column    => 'history_id',
      on_delete => 'CASCADE',
    );
  };

  create_table user_english_park_equipment_edit_history_row => columns {
    integer 'row_id' => (primary_key, auto_increment);
    integer 'history_id';
    string 'equipment_name';
    string 'equipment_comment';

    add_unique_index 'user_english_park_equipment_edit_history_row_unique' =>
      [qw( history_id equipment_name )];
    belongs_to user_park_equipment_edit_history_row => (
      column    => 'row_id',
      on_delete => 'CASCADE',
    );
    belongs_to user_park_equipment_edit_history => (
      column    => 'history_id',
      on_delete => 'CASCADE',
    );
  };

  create_table user_park_surrounding_facilitiy_edit_history => columns {
    integer 'id' => (primary_key, auto_increment);
    integer 'park_id';
    integer 'editer_seacret_id';
    bigint 'edited_time';

    belongs_to park => (
      column    => 'park_id',
      on_delete => 'CASCADE',
    );
    foreign_key editer_seacret_id => (
      user      => 'seacret_id',
      on_delete => 'SET NULL',
    );
  };

  create_table user_park_surrounding_facilitiy_edit_history_row => columns {
    integer 'id' => (primary_key, auto_increment);
    integer 'history_id';
    string 'surrounding_facilitiy_name';
    string 'surrounding_facilitiy_comment';

    add_unique_index user_park_surrounding_facilitiy_edit_history_row_unique =>
      [qw( history_id surrounding_facilitiy_name )];
    belongs_to user_park_surrounding_facilitiy_edit_history => (
      column    => 'history_id',
      on_delete => 'CASCADE',
    );
  };

  create_table user_english_park_surrounding_facilitiy_edit_history_row => columns {
    integer 'row_id' => (primary_key, auto_increment);
    integer 'history_id';
    string 'surrounding_facilitiy_name';
    string 'surrounding_facilitiy_comment';

    add_unique_index user_english_park_surrounding_facilitiy_edit_history_row_unique =>
      [qw( history_id surrounding_facilitiy_name )];
    belongs_to user_park_surrounding_facilitiy_edit_history_row => (
      column    => 'row_id',
      on_delete => 'CASCADE',
    );
    belongs_to user_park_surrounding_facilitiy_edit_history => (
      column    => 'history_id',
      on_delete => 'CASCADE',
    );
  };

}

1;
