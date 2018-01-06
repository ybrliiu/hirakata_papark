package HirakataPapark::Model::Users::ParkEditHistories::Park::SelectColumnsMaker {

  use Mouse;
  use Option;
  use HirakataPapark;
  use HirakataPapark::Exception;

  has [qw/ table join_table /] => (
    is         => 'ro',
    isa        => 'Aniki::Schema::Table',
    lazy_build => 1,
  );

  has 'duplicate_columns' => (
    is      => 'ro',
    isa     => 'ArrayRef[Aniki::Schema::Table::Field]',
    lazy    => 1,
    builder => '_build_duplicate_columns',
  );

  has 'duplicate_columns_table' => (
    is      => 'ro',
    isa     => 'HashRef[Aniki::Schema::Table::Field]',
    lazy    => 1,
    builder => '_build_duplicate_columns_table',
  );

  has 'select_columns' => (
    is      => 'ro',
    isa     => 'ArrayRef[Str]',
    lazy    => 1,
    builder => '_build_select_columns',
  );

  has 'join_condition' => (
    is      => 'ro',
    isa     => 'HashRef[Str]',
    lazy    => 1,
    builder => '_build_join_condition',
  );

  sub _build_duplicate_columns($self) {
    my %fields = map {
      my $key = $_;
      my %fields_table = map { 
        my $field = $_;
        $field->name => $field;
      } $self->$key->get_fields;
      $key => \%fields_table;
    } qw( table join_table );
    my @duplicate_fields = map { $fields{join_table}->{$_} }
      grep { exists $fields{table}->{$_} && exists $fields{join_table}->{$_} }
      map { $_->name } $self->join_table->get_fields;
    \@duplicate_fields;
  }

  sub _build_duplicate_columns_table($self) {
    +{ map { $_->name => $_ } $self->duplicate_columns->@* };
  }

  sub _build_select_columns($self) {
    [ map { $_->table->name . '.' . $_->name } $self->duplicate_columns->@* ];
  }

  sub _build_join_condition($self) {
    my $func = sub ($table) {
      option( $table->primary_key )->match(
        Some => sub ($pk) { ($pk->fields)[0] },
        None => sub { HirakataPapark::Exception->throw("table @{[ $table->name ]} doesn't have primary key.") },
      );
    };
    my $table_pk      = $func->($self->table);
    my $join_table_pk = $func->($self->join_table);
    +{ map { $_->table->name . '.' . $_->name } ($join_table_pk, $table_pk) };
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

とってくるRoWオブジェクトのカラムを生成する(推測する?)処理を行うクラス

