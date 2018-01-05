package HirakataPapark::Model::Role::DB::ForeignLanguage::SelectColumnsMaker {

  use Mouse;
  use Option;
  use HirakataPapark;
  use HirakataPapark::Exception;

  has 'schema' => (
    is       => 'ro',
    isa      => 'Aniki::Schema',
    required => 1,
  );

  has [qw/ table_name orig_lang_table_name /] => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
  );

  has [qw/ table orig_lang_table /] => (
    is         => 'ro',
    isa        => 'Aniki::Schema::Table',
    lazy_build => 1,
  );

  has 'not_need_columns' => (
    is      => 'ro',
    isa     => 'ArrayRef[Str]',
    default => sub { [] },
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

  has 'output_for_sql' => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    builder => '_build_output_for_sql',
  );

  has 'output_join_condition_for_sql' => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    builder => '_build_output_join_condition_for_sql',
  );

  sub _build_table;
  sub _build_orig_lang_table;
  {
    my $table_builder = sub ($self, $table_name) {
      option( $self->schema->get_table($table_name) )->match(
        Some => sub ($table) { $table },
        None => sub { HirakataPapark::Exception->throw("table ${table_name} is not defined.") },
      );
    };

    my $meta = __PACKAGE__->meta;
    $meta->add_method(_build_table           => sub ($self) { $self->$table_builder($self->table_name) });
    $meta->add_method(_build_orig_lang_table => sub ($self) { $self->$table_builder($self->orig_lang_table_name) });
  }

  sub _build_select_columns($self) {
    my @table_fields           = $self->table->get_fields;
    my @orig_lang_table_fields = $self->orig_lang_table->get_fields;
    my %fields_name = map { $_->name => $_ } ( @orig_lang_table_fields, @table_fields );
    # 不必要なデータがあれば $self->not_need_columns にカラム名をセットして削除できる
    delete @fields_name{$self->not_need_columns->@*};
    [ map { $_->table->name . '.' . $_->name } sort { $a->name cmp $b->name } values %fields_name ];
  }

  sub _build_join_condition($self) {
    my $func = sub ($table) {
      option( $table->primary_key )->match(
        Some => sub ($pk) { ($pk->fields)[0] },
        None => sub { HirakataPapark::Exception->throw("table @{[ $table->name ]} doesn't have primary key.") },
      );
    };
    my $table_pk = $func->($self->table);
    # olt = orig_lang_table :(
    my $olt_pk   = $func->($self->orig_lang_table);
    +{ map { $_->table->name . '.' . $_->name } ($olt_pk, $table_pk) };
  }

  sub _build_output_for_sql($self) {
    join ", ", $self->select_columns->@*;
  }

  sub _build_output_join_condition_for_sql($self) {
    my @conditions = $self->join_condition->%*;
    join ' = ', @conditions;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

HirakataPapark::Model::Role::DB::ForeignLanguage にて
join_and_select でとってくるRoWオブジェクトのカラムを生成する(推測する?)処理を行うクラス

