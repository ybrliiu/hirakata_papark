package HirakataPapark::Model::Users::ParkEditHistories::Equipment::ResultHistoryBuilder {
  
  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;
  use HirakataPapark::Model::Users::ParkEditHistories::Equipment::Equipment;
  use HirakataPapark::Model::Users::ParkEditHistories::Equipment::LangRecord;
  use HirakataPapark::Model::Users::ParkEditHistories::OneToMany::Item::Result;
  use HirakataPapark::Model::Users::ParkEditHistories::OneToMany::LangRecords;
  use HirakataPapark::Model::Users::ParkEditHistories::OneToMany::History::Result;

  my $Equipment   = 'HirakataPapark::Model::Users::ParkEditHistories::Equipment::Equipment';
  my $LangRecord  = 'HirakataPapark::Model::Users::ParkEditHistories::Equipment::LangRecord';
  my $Item        = 'HirakataPapark::Model::Users::ParkEditHistories::OneToMany::Item::Result';
  my $LangRecords = 'HirakataPapark::Model::Users::ParkEditHistories::OneToMany::LangRecords';
  my $History     = 'HirakataPapark::Model::Users::ParkEditHistories::OneToMany::History::Result';

  has 'meta_tables' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Model::Users::ParkEditHistories::Equipment::MetaTables',
    required => 1,
  );

  has 'sth' => (
    is       => 'ro',
    isa      => 'DBI::st',
    required => 1,
  );

  has 'rows' => (
    is       => 'ro',
    isa      => 'ArrayRef[ArrayRef]',
    required => 1,
  );

  has 'lang' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Types::Lang',
    required => 1,
  );

  sub _build_items($self) {
    [ map { $self->_build_item($_) } $self->rows->@* ];
  }

  sub _build_item($self, $row) {
    my $begin = $self->meta_tables->body_table->select_columns->@*;
    my $end = $begin + $#{ $self->meta_tables->default_lang_table->select_columns };
    my (%params, %default_lang_record_params);
    my $prefix_length = length $Equipment->build_prefix;
    for my $i ($begin .. $end) {
      my $column_name = $self->sth->{NAME}[$i];
      my $attr_name = substr $column_name, $prefix_length;
      if ( $self->meta_tables->is_column_exists_in_duplicate_columns($column_name) ) {
        $default_lang_record_params{$attr_name} = $row->[$i];
      } else {
        $params{$attr_name} = $row->[$i];
      }
    }
    my $default_lang_record = $LangRecord->new(\%default_lang_record_params);
    my $lang_records = $self->_build_lang_records($row, $end + 1);
    $lang_records->${\HirakataPapark::Types->DEFAULT_LANG}($default_lang_record);
    my $equipment = $Equipment->new({
      %params,
      lang_records => $lang_records,
    });
    $Item->new({
      lang      => $self->lang,
      item_impl => $equipment,
    });
  }

  sub _build_lang_records($self, $row, $begin) {
    my %params = map {
      my $table = $_;
      my $lang_record = $self->_build_lang_record($row, $begin, $table);
      $begin += $table->select_columns->@*;
      $table->lang => $lang_record;
    } $self->meta_tables->foreign_lang_tables->@*;
    $LangRecords->new(\%params);
  }

  sub _build_lang_record($self, $row, $begin, $table) {
    my $end = $begin + $#{ $table->select_columns };
    my $prefix_length = length $LangRecord->build_prefix;
    my %params = map {
      my $attr_name = substr $self->sth->{NAME}[$_], $prefix_length;
      $attr_name => $row->[$_];
    } $begin .. $end;
    $LangRecord->new(\%params);
  }

  sub build($self) {
    my $end = $#{ $self->meta_tables->body_table->select_columns };
    my $row = $self->rows->[0];
    my %params;
    for my $i (0 .. $end) {
      my $attr_name = $self->sth->{NAME}[$i];
      $params{$attr_name} = $row->[$i];
    }
    $History->new({
      %params,
      items => $self->_build_items,
    });
  }
  
  __PACKAGE__->meta->make_immutable;

}

1;
