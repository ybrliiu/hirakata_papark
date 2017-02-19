package HirakataPapark::Model::Parks::Tags {

  use Mouse;
  use HirakataPapark;

  use Set::Object;
  use Smart::Args qw( args args_pos );

  use constant TABLE => 'park_tag';

  with 'HirakataPapark::Model::Role::DB';

  sub add_row {
    args my $self, my $park_id => 'Int', my $name => 'Str';
    $self->insert({
      park_id => $park_id,
      name    => $name
    });
  }

  sub get_rows_by_name {
    args_pos my $self, my $name => 'Str';
    [ $self->select({name => $name})->all ];
  }

  sub get_tag_list {
    my $self = shift;
    my @tag_list = map { $_->name } $self->select({}, {columns => ['name']})->all;
    [ Set::Object::set(@tag_list)->elements ];
  }

  __PACKAGE__->meta->make_immutable;

}

1;

