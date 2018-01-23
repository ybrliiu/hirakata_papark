package HirakataPapark::Model::Parks::Tags {

  use Mouse;
  use HirakataPapark;
  use Smart::Args qw( args );

  use constant HANDLE_TABLE_NAME => 'park_tag';

  with qw(
    HirakataPapark::Model::Role::DB::RowHandler
    HirakataPapark::Model::Role::DB::RelatedToPark
  );

  sub add_row {
    args my $self, my $park_id => 'Int', my $name => 'Str';
    $self->insert({
      park_id => $park_id,
      name    => $name
    });
  }

  sub get_tag_list($self) {
    my @tag_list = map { $_->name }
      $self->select( {}, { prefix => 'SELECT DISTINCT', columns => ['name'] } )->all;
    \@tag_list;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

