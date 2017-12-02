package HirakataPapark::DB::Schema {

  use HirakataPapark;
  use DBIx::Schema::DSL;
  use Aniki::Schema::Relationship::Declare;

  database 'PostgreSQL';

  default_not_null;

  create_table park => columns {
    integer 'id' => (primary_key, auto_increment);
    string 'name' => (unique);
    string 'address';
    string 'explain' => (default => '');
    string 'remarks_about_plants' => (default => '');
    integer 'good_count' => (default => 0);
    double 'x';
    double 'y';
    double 'area';
    smallint 'is_nice_scenery' => (default => 0);
    smallint 'is_evacuation_area' => (default => 0);

    add_index 'park_name_index' => ['name'];
  };

  create_table english_park => columns {
    integer 'id' => (primary_key);
    string 'english_name' => (unique); # SQL::Translator の仕様変更がなされれば 'name' に変更
    string 'address';
    string 'explain' => (default => '');

    foreign_key 'id' => (park => 'id');
  };

  create_table park_equipment => columns {
    integer 'id' => (primary_key, auto_increment);
    integer 'park_id';
    string 'name';
    string 'comment';
    integer 'recommended_age' => (default => 0);
    integer 'num' => (default => 1);

    add_unique_index 'park_equipment_unique' => ['park_id', 'name'];
    foreign_key 'park_id' => (park => 'id');
  };

  create_table english_park_equipment => columns {
    integer 'id' => (primary_key);
    integer 'park_id';
    string 'name';
    string 'comment';

    add_unique_index 'english_park_equipment_unique' => ['park_id', 'name'];
    foreign_key 'id' => (park_equipment => 'id');
    foreign_key 'park_id' => (english_park => 'id');
  };

  create_table park_surrounding_facility => columns {
    integer 'id' => (primary_key, auto_increment);
    integer 'park_id';
    string 'name';
    string 'comment';

    add_unique_index 'park_surrounding_facility_unique' => ['park_id', 'name'];
    foreign_key 'park_id' => (park => 'id');
  };

  create_table english_park_surrounding_facility => columns {
    integer 'id' => (primary_key);
    integer 'park_id';
    string 'name';
    string 'comment';

    add_unique_index 'english_park_surrounding_facility_unique' => ['park_id', 'name'];
    foreign_key 'id' => (park_surrounding_facility => 'id');
    foreign_key 'park_id' => (english_park => 'id');
  };

  create_table park_plants => columns {
    integer 'id' => (primary_key, auto_increment);
    integer 'park_id';
    string 'name';
    string 'category';
    string 'comment';
    integer 'num' => (default => 1);

    add_unique_index 'park_plants_unique' => ['park_id', 'name'];
    foreign_key 'park_id' => (park => 'id');
  };

  create_table english_park_plants => columns {
    integer 'id' => (primary_key);
    integer 'park_id';
    string 'name';
    string 'category';
    string 'comment';

    add_unique_index 'english_park_plants_unique' => ['park_id', 'name'];
    foreign_key 'id' => (park_plants => 'id');
    foreign_key 'park_id' => (english_park => 'id');
  };

  create_table park_tag => columns {
    integer 'park_id';
    string 'name';

    set_primary_key qw( park_id name );
    foreign_key 'park_id' => (park => 'id');
  };

  create_table park_event => columns {
    integer 'id' => (primary_key, auto_increment);
    integer 'park_id';
    string 'title';
    text 'explain';

    foreign_key 'park_id' => (park => 'id');
  };

  create_table park_comment => columns {
    integer 'park_id';
    integer 'id' => (primary_key, auto_increment);
    string 'name';
    bigint 'time';
    text 'message';

    foreign_key 'park_id' => (park => 'id');
  };

  create_table park_news => columns {
    integer 'park_id';
    integer 'id', (primary_key, auto_increment);
    string 'title';
    text 'message';

    foreign_key 'park_id' => (park => 'id');
  };

  create_table user => columns {
    integer 'seacret_id' => (primary_key, auto_increment);
    string 'id' => (unique);
    string 'user_name' => (unique); # SQL::Translator が修正されたら 'name' に変更
    string 'password';

    string 'address' => (default => '');
    string 'profile' => (default => '');

    add_index 'user_id_index' => ['id'];
  };

}

1;

