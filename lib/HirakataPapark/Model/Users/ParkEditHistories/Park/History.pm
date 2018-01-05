package HirakataPapark::Model::Users::ParkEditHistories::Park::History {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;

  use constant ForeignLangTableSets =>
    'HirakataPapark::Model::Users::ParkEditHistories::Park::ForeignLangTableSets';
    
  has 'lang' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Types::Lang',
    required => 1,
  );

  # 履歴本体のテーブルのカラム
  has 'park_id' => (
    is       => 'ro',
    isa      => 'Int',
    required => 1,
  );

  has 'editer_seacret_id' => (
    is       => 'ro',
    isa      => 'Int',
    required => 1,
  );

  has 'edited_time' => (
    is      => 'ro',
    isa     => 'Int',
    default => sub { time },
  );

  has 'park_zipcode' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
  );

  for my $name ( map { "park_$_" } qw( x y area ) ) {
    has $name => (
      is       => 'ro',
      isa      => 'Num',
      required => 1,
    );
  }

  has 'park_is_evacuation_area' => (
    is       => 'ro',
    isa      => 'Bool',
    required => 1,
  );

  has 'foreign_lang_table_sets' => (
    is       => 'ro',
    isa      => ForeignLangTableSets,
    handles  => [qw( has_all )],
    required => 1,
  );

  my $meta = __PACKAGE__->meta;
  for my $column_name ( map { "park_$_" } qw( name address explain ) ) {
    $meta->add_method($column_name => sub ($self) {
      $self->foreign_lang_table_sets->get_sets($self->lang)->get->$column_name;
    })
  }

  $meta->make_immutable;

}

1;
