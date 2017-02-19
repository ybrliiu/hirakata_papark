package HirakataPapark::Model::Parks::Equipments {

  use Mouse;
  use HirakataPapark;

  use Encode;
  use Set::Object;
  use Smart::Args qw( args args_pos );

  use constant TABLE => 'park_equipment';

  with 'HirakataPapark::Model::Role::DB';

  sub add_row {
    args my $self, my $park_id => 'Int', my $name => 'Str',
      my $recommended_age => { isa => 'Int', default => 0 },
      my $comment         => { isa => 'Str', default => '' },
      my $num             => { isa => 'Int', default => 1 };
    $self->insert({
      park_id         => $park_id,
      name            => $name,
      recommended_age => $recommended_age,
      comment         => $comment,
      num             => $num,
    });
  }

  sub get_rows_by_name {
    args_pos my $self, my $name => 'Str';
    [ $self->select({name => $name})->all ];
  }

  sub get_rows_by_names {
    args_pos my $self, my $names => 'ArrayRef[Str]';
    my @ary = map { ('=', $_) } @$names;
    [ $self->select({ name => \@ary })->all ];
  }

  sub get_equipment_list {
    my $self = shift;
    my @tag_list = map { $_->name } $self->select({}, {columns => ['name']})->all;
    [ map { Encode::decode_utf8 $_ } Set::Object::set(@tag_list)->elements ];
  }

  __PACKAGE__->meta->make_immutable;

}

1;
