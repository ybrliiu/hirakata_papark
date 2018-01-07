package HirakataPapark::Model::Users::ParkEditHistories::Park::ResultHistoryBuilder {
  
  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;
  use HirakataPapark::Model::Users::ParkEditHistories::Park::DiffColumnSets;
  use HirakataPapark::Model::Users::ParkEditHistories::Park::ForeignLangTableSets;
  use HirakataPapark::Model::Users::ParkEditHistories::Park::History::Result;

  # alias
  use constant {
    DiffColumnSets =>
      'HirakataPapark::Model::Users::ParkEditHistories::Park::DiffColumnSets',
    ForeignLangTableSets =>
      'HirakataPapark::Model::Users::ParkEditHistories::Park::ForeignLangTableSets',
    ResultHistory => 
      'HirakataPapark::Model::Users::ParkEditHistories::Park::History::Result',
  };

  has 'tables' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Model::Users::ParkEditHistories::Park::Tables',
    required => 1,
  );

  has 'sth' => (
    is       => 'ro',
    isa      => 'DBI::st',
    required => 1,
  );

  has 'row' => (
    is       => 'ro',
    isa      => 'ArrayRef',
    required => 1,
  );

  has 'lang' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Types::Lang',
    required => 1,
  );

  has 'history_params' => (
    is      => 'ro',
    isa     => 'HashRef',
    default => sub { +{} },
  );

  has 'foreign_lang_table_sets_params' => (
    is      => 'ro',
    isa     => 'HashRef',
    builder => '_build_foreign_lang_table_sets_params',
  );

  has 'body_table_columns_last_index' => (
    is      => 'ro',
    isa     => 'Int',
    lazy    => 1,
    builder => '_build_body_table_columns_last_index',
  );

  has 'structures_for_set_params_to_foreign_lang_table_sets_params' => (
    is      => 'ro',
    isa     => 'ArrayRef[HashRef]',
    lazy    => 1,
    builder => '_build_structures_for_set_params_to_foreign_lang_table_sets_params',
  );

  sub _build_body_table_columns_last_index($self) {
    $#{[ $self->tables->body_table->get_fields ]};
  }

  sub _build_foreign_lang_table_sets_params($self) {
    +{ map { $_ => {} } HirakataPapark::Types->LANGS->@* };
  }

  sub _build_structures_for_set_params_to_foreign_lang_table_sets_params($self) {
    my @duplicate_columns        = $self->tables->duplicate_columns->@*;
    my $duplicate_columns_length = @duplicate_columns;
    state $foreign_langs = HirakataPapark::Types->FOREIGN_LANGS;
    my @structures = map {
      my $lang_index = $_;
      my $lang       = $foreign_langs->[$lang_index];
      map {
        my $duplicate_column_index = $_;
        my $duplicate_column       = $duplicate_columns[$duplicate_column_index];
        my $row_index = 
            $self->body_table_columns_last_index
          + ( $duplicate_column_index + 1 )
          + ( $lang_index * $duplicate_columns_length );
        +{
          lang        => $lang,
          column_name => $duplicate_column->name,
          index       => $row_index,
        };
      } 0 .. $#duplicate_columns;
    } 0 .. $#$foreign_langs;
    \@structures;
  }

  sub set_params_from_body_table_row($self) {
    for my $index (0 .. $self->body_table_columns_last_index) {
      my ($column_name, $value) = ($self->sth->{NAME}[$index], $self->row->[$index]);
      if ( $self->tables->duplicate_columns_table->{$column_name} ) {
        state $default_lang = HirakataPapark::Types->DEFAULT_LANG;
        $self->foreign_lang_table_sets_params->{$default_lang}{$column_name} = $value;
      } else {
        $self->history_params->{$column_name} = $value;
      }
    }
  }

  sub set_params_from_foreign_lang_tables_row($self) {
    my @structures = 
      $self->structures_for_set_params_to_foreign_lang_table_sets_params->@*;
    for my $struct (@structures) {
      my ($lang, $column_name, $index) = @$struct{qw( lang column_name index )};
      $self->foreign_lang_table_sets_params->{$lang}{$column_name} = $self->row->[$index];
    }
  }

  sub build_diff_column_sets($self) {
    for my $lang (keys $self->foreign_lang_table_sets_params->%*) {
      $self->foreign_lang_table_sets_params->{$lang} =
        DiffColumnSets->new($self->foreign_lang_table_sets_params->{$lang});
    }
  }

  sub build_foreign_lang_table_sets($self) {
    $self->history_params->{foreign_lang_table_sets} = 
      ForeignLangTableSets->new($self->foreign_lang_table_sets_params);
  }

  sub build_history($self) {
    $self->set_params_from_body_table_row;
    $self->set_params_from_foreign_lang_tables_row;
    $self->build_diff_column_sets;
    $self->build_foreign_lang_table_sets;
    $self->history_params->{lang} = $self->lang;
    ResultHistory->new($self->history_params);
  }
  
  __PACKAGE__->meta->make_immutable;

}

1;
