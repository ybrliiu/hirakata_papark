package HirakataPapark::Model::Parks::Comments {

  use Mouse;
  use HirakataPapark;

  use Smart::Args qw( args );

  use constant TABLE => 'park_comment';

  with 'HirakataPapark::Model::Role::DB';

  sub add_row {
    args my $self, my $park_id => 'Int', my $message => 'Str',
      my $name => { isa => 'Str', default => '名無し' };
    $self->insert({
      park_id => $park_id,
      message => $message,
      name    => $name,
      time    => join '', localtime(),
    });
  }
  
  __PACKAGE__->meta->make_immutable;

}

1;

