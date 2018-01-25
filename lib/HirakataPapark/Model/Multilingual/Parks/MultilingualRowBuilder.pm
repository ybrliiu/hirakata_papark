package HirakataPapark::Model::Multilingual::Parks::MultilingualRowBuilder {
  
  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;
  use aliased 'HirakataPapark::Model::Multilingual::Parks::LangRecord';
  use aliased 'HirakataPapark::Model::Multilingual::Parks::LangRecords';
  use aliased 'HirakataPapark::Model::Multilingual::Parks::MultilingualRow';

  has 'tables_meta' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Model::Role::DB::TablesMeta::Multilingual::HasOne',
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

  sub _build_lang_record($self, $first, $table) {
    my $last = $first + $#{ $table->select_columns };
    my %params = map {
      my $attr_name = $self->sth->{NAME}[$_];
      $attr_name => $self->row->[$_];
    } $first .. $last;
    LangRecord->new(\%params);
  }

  sub _build_lang_records($self, $first, $default_lang_record) {
    my %params = map {
      my $table = $_;
      my $lang_record = $self->_build_lang_record($first, $table);
      $first += $table->select_columns->@*;
      $table->lang => $lang_record;
    } $self->tables_meta->foreign_lang_tables->@*;
    LangRecords->new({
      HirakataPapark::Types->DEFAULT_LANG, => $default_lang_record,
      %params
    });
  }

  sub build($self) {
    my $body_table = $self->tables_meta->body_table;
    my $last       = $#{ $body_table->select_columns };
    my (%params, %default_lang_record_params);
    for my $i (0 .. $last) {
      my $column_name = $self->sth->{NAME}[$i];
      if ( $self->tables_meta->is_column_exists_in_duplicate_columns($column_name) ) {
        $default_lang_record_params{$column_name} = $self->row->[$i];
      } else {
        $params{$column_name} = $self->row->[$i];
      }
    }
    my $default_lang_record = LangRecord->new(\%default_lang_record_params);
    my $lang_records = $self->_build_lang_records($last + 1, $default_lang_record);
    MultilingualRow->new({
      lang         => $self->lang,
      lang_records => $lang_records,
      %params,
    });
  }
  
  __PACKAGE__->meta->make_immutable;

}

1;
