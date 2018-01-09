package HirakataPapark::Model::Users::ParkEditHistories::ResultHistoryBuilder::HasMany {
  
  use Mouse::Role;
  use HirakataPapark;
  use HirakataPapark::Types;
  use HirakataPapark::Model::Users::ParkEditHistories::History::Item::Result;
  use HirakataPapark::Model::Users::ParkEditHistories::History::LangRecords;
  use HirakataPapark::Model::Users::ParkEditHistories::History::History::HasMany::Result;

  my $Item        = 'HirakataPapark::Model::Users::ParkEditHistories::History::Item::Result';
  my $LangRecords = 'HirakataPapark::Model::Users::ParkEditHistories::History::LangRecords';
  my $History     = 'HirakataPapark::Model::Users::ParkEditHistories::History::History::HasMany::Result';

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

  has 'prefix_length' => (
    is      => 'ro',
    isa     => 'Int',
    lazy    => 1,
    builder => '_build_prefix_length',
  );

  # methods
  requires qw( _build_prefix_length _create_item_impl _create_lang_record );

  sub _build_items($self) {
    [ map { $self->_build_item($_) } $self->rows->@* ];
  }

  sub _build_item($self, $row) {
    my $begin = $self->meta_tables->body_table->select_columns->@*;
    my $end = $begin + $#{ $self->meta_tables->default_lang_table->select_columns };
    my (%params, %default_lang_record_params);
    for my $i ($begin .. $end) {
      my $column_name = $self->sth->{NAME}[$i];
      my $attr_name = substr $column_name, $self->prefix_length;
      if ( $self->meta_tables->is_column_exists_in_duplicate_columns($column_name) ) {
        $default_lang_record_params{$attr_name} = $row->[$i];
      } else {
        $params{$attr_name} = $row->[$i];
      }
    }
    my $default_lang_record = 
      $self->_create_lang_record(\%default_lang_record_params);
    my $lang_records = $self->_build_lang_records($row, $end + 1);
    $lang_records->${\HirakataPapark::Types->DEFAULT_LANG}($default_lang_record);
    $Item->new({
      lang      => $self->lang,
      item_impl => $self->_create_item_impl({
        %params,
        lang_records => $lang_records,
      }),
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
    my %params = map {
      my $attr_name = substr $self->sth->{NAME}[$_], $self->prefix_length;
      $attr_name => $row->[$_];
    } $begin .. $end;
    $self->_create_lang_record(\%params);
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

}

1;
