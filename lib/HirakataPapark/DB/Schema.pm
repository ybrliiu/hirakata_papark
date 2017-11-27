package HirakataPapark::DB::Schema {

  use HirakataPapark;
  use DBIx::Schema::DSL;
  use Aniki::Schema::Relationship::Declare;

  database 'PostgreSQL';

  default_not_null;

  create_table park => columns {
    integer 'id' => (primary_key, auto_increment);
    string 'name' => (unique);
    string 'english_name' => (unique);
    string 'address';
    string 'english_address';
    string 'explain' => (default => '');
    string 'english_explain' => (default => '');
    string 'remarks_about_plants' => (default => '');
    integer 'good_count' => (default => 0);
    double 'x';
    double 'y';
    double 'area';
    smallint 'is_nice_scenery' => (default => 0);
    smallint 'is_evacuation_area' => (default => 0);

    add_index 'park_name_index' => ['name'];
  };

  create_table park_equipment => columns {
    integer 'park_id';
    string 'name';
    string 'english_name';
    string 'comment';
    string 'english_comment';
    integer 'recommended_age' => (default => 0);
    integer 'num' => (default => 1);

    foreign_key 'park_id' => (park => 'id');
  };

  create_table park_surrounding_facility => columns {
    integer 'park_id';
    string 'name';
    string 'english_name';
    string 'comment';
    string 'english_comment';

    foreign_key 'park_id' => (park => 'id');
  };

  create_table park_plants => columns {
    integer 'park_id';
    string 'name';
    string 'english_name';
    string 'category';
    string 'english_category';
    string 'comment';
    string 'english_comment';
    integer 'num' => (default => 1);

    foreign_key 'park_id' => (park => 'id');
  };

  create_table park_tag => columns {
    integer 'park_id';
    string 'name';

    set_primary_key qw( park_id name );
    foreign_key 'park_id' => (park => 'id');
  };

  create_table park_event => columns {
    integer 'park_id';
    integer 'id', primary_key, auto_increment;
    string 'title';
    text 'explain';

    foreign_key 'park_id' => (park => 'id');
  };

  create_table park_comment => columns {
    integer 'park_id';
    integer 'id', primary_key, auto_increment;
    string 'name';
    bigint 'time';
    text 'message';

    foreign_key 'park_id' => (park => 'id');
  };

  create_table park_news => columns {
    integer 'park_id';
    integer 'id', primary_key, auto_increment;
    string 'title';
    text 'message';

    foreign_key 'park_id' => (park => 'id');
  };

  create_table user => columns {
    integer 'seacret_id' => (primary_key, auto_increment);
    integer 'id' => (unique);
    string 'name'; # SQL::Translator::Producer::PostgreSQL が修正されたら unique をつける
    string 'password';
    string 'twitter_id' => (default => '');
    string 'facebook_id' => (default => '');

    string 'address' => (default => '');
    string 'profile' => (default => '');

    add_index 'user_id_index' => ['id'];
  };

}

1;

