package HirakataPapark::Model::Parks::Parks::Comments {

  use Mouse;
  use HirakataPapark;

  use Smart::Args qw( args );
  use HTML::Escape qw( escape_html );
  use HirakataPapark::Util qw( escape_indention );

  use constant TABLE => 'park_comment';

  with 'HirakataPapark::Model::Role::DB';

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
    $self->result_class->new([
      $self->select(
        { park_id => $park_id },
        { limit => $num, order_by => {id => 'DESC'} },
      )->all
    ]);
  }
  
  __PACKAGE__->meta->make_immutable;

}

1;

