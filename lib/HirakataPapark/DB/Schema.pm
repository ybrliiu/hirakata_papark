package HirakataPapark::DB::Schema {

  use HirakataPapark;
  use DBIx::Schema::DSL;
  use Aniki::Schema::Relationship::Declare;

  database 'PostgreSQL';

  create_table park => columns {
    integer id => (primary_key, auto_increment);
    string name => (unique);
    integer good_count => (default => 0);
    double 'x_coordinate';
    double 'y_coordinate';
    double 'area';

    add_index name_index => ['name'];
  };

  create_table park_equipment => columns {
    integer 'park_id';
    string 'name';
    integer 'num';
    string 'comment';

    belongs_to 'park';
    foreign_key park_id => (park => 'id');
  };

  create_table park_tag => columns {
    integer 'park_id';
    string 'name';

    set_primary_key qw( park_id name );
    belongs_to 'park';
    foreign_key park_id => (park => 'id');
  };

  create_table park_event => columns {
    integer 'park_id';
    integer 'id', primary_key, auto_increment;
    string 'title';
    text 'explain';

    belongs_to 'park';
    foreign_key park_id => (park => 'id');
  };

  create_table park_comment => columns {
    integer 'park_id';
    integer 'id', primary_key, auto_increment;
    string 'name';
    text 'message';

    belongs_to 'park';
    foreign_key park_id => (park => 'id');
  };

  create_table park_news => columns {
    integer 'park_id';
    integer 'id', primary_key, auto_increment;
    string 'title';
    text 'message';

    belongs_to 'park';
    foreign_key park_id => (park => 'id');
  };

}

1;

