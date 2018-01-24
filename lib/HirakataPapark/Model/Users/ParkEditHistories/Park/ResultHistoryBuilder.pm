package HirakataPapark::Model::Users::ParkEditHistories::Park::ResultHistoryBuilder {
  
  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;
  use aliased 'HirakataPapark::Model::Users::ParkEditHistories::Park::Park';
  use aliased 'HirakataPapark::Model::Users::ParkEditHistories::Park::LangRecord';
  use aliased 'HirakataPapark::Model::Users::ParkEditHistories::History::LangRecords';
  use aliased 
    'HirakataPapark::Model::Users::ParkEditHistories::History::History::HasOne::Result' => 'History';

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

  sub _build_history_params($self) {
    my $params = {};
    my $end    = $#{ History->COLUMN_NAMES };
    for my $i (0 .. $end) {
      my $column_name = $self->sth->{NAME}[$i];
      $params->{$column_name} = $self->row->[$i];
    }
    $params;
  }

  sub _build_lang_record($self, $begin, $table) {
    my $end = $begin + $#{ $table->select_columns };
    my $prefix_length = length LangRecord->build_prefix;
    my %params = map {
      my $attr_name = substr $self->sth->{NAME}[$_], $prefix_length;
      $attr_name => $self->row->[$_];
    } $begin .. $end;
    LangRecord->new(\%params);
  }

  sub _build_lang_records($self, $begin) {
    my %params = map {
      my $table = $_;
      my $lang_record = $self->_build_lang_record($begin, $table);
      $begin += $table->select_columns->@*;
      $table->lang => $lang_record;
    } $self->tables_meta->foreign_lang_tables->@*;
    LangRecords->new(\%params);
  }

  sub build($self) {
    my $body_table = $self->tables_meta->body_table;
    my $begin = History->COLUMN_NAMES->@*;
    my $end   = $#{ $body_table->select_columns };
    my (%params, %default_lang_record_params);
    my $prefix_length = length Park->build_prefix;
    for my $i ($begin .. $end) {
      my $column_name = $self->sth->{NAME}[$i];
      my $attr_name   = substr $column_name, $prefix_length;
      if ( $self->tables_meta->is_column_exists_in_duplicate_columns($column_name) ) {
        $default_lang_record_params{$attr_name} = $self->row->[$i];
      } else {
        $params{$attr_name} = $self->row->[$i];
      }
    }
    my $default_lang_record = LangRecord->new(\%default_lang_record_params);
    my $lang_records = $self->_build_lang_records($end + 1);
    $lang_records->${\HirakataPapark::Types->DEFAULT_LANG}($default_lang_record);
    History->new({
      $self->_build_history_params->%*,
      lang      => $self->lang,
      item_impl => Park->new({
        %params,
        lang_records => $lang_records,
      }),
    });
  }
  
  __PACKAGE__->meta->make_immutable;

}

1;
