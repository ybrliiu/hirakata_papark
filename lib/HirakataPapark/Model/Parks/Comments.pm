package HirakataPapark::Model::Parks::Comments {

  use Mouse;
  use HirakataPapark;

  use Smart::Args qw( args );
  use HTML::Escape qw( escape_html );
  use HirakataPapark::Util qw( escape_indention );

  use constant HANDLE_TABLE_NAME => 'park_comment';

  with 'HirakataPapark::Model::Role::DB::RowHandler';

  sub add_row {
    args my $self, my $park_id => 'Int', my $message => 'Str',
      my $name => { isa => 'Str', default => '名無し' };
    $self->insert({
      park_id => $park_id,
      message => $message,
      name    => $name,
      time    => time(),
    });
  }

  sub get_rows_by_park_id($self, $park_id, $num) {
    $self->create_result(
      $self->select(
        { park_id => $park_id },
        { limit => $num, order_by => {id => 'DESC'} },
      )->rows
    );
  }
  
  __PACKAGE__->meta->make_immutable;

}

1;

