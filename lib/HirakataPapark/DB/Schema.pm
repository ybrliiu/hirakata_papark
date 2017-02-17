package HirakataPapark::DB::Schema {

  use HirakataPapark;
  use DBIx::Schema::DSL;
  use Aniki::Schema::Relationship::Declare;

  database 'PostgreSQL';

  create_table park => columns {
    integer 'id' => (primary_key, auto_increment);
    string 'name' => (unique);
    string 'address';
    integer 'good_count' => (default => 0);
    double 'x';
    double 'y';
    double 'area';

    add_index 'name_index' => ['name'];
  };

  create_table park_equipment => columns {
    integer 'park_id';
    string 'name';
    integer 'num' => (default => 1);
    string 'comment';

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

}

1;

