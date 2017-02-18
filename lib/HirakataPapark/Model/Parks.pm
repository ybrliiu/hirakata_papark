package HirakataPapark::Model::Parks {

  use Mouse;
  use HirakataPapark;

  use Smart::Args qw( args args_pos );
  
  use constant TABLE => 'park';

  with 'HirakataPapark::Model::Role::DB';

  sub add_row {
    args my $self, my $name => 'Str',
      my $address => 'Str', my $x => 'Num', my $y => 'Num', my $area => 'Num';
    $self->insert({
      name    => $name,
      address => $address,
      x       => $x,
      y       => $y,
      area    => $area,
    });
  }

  sub add_rows {
    args_pos my $self, my $hash_list => 'ArrayRef[HashRef]';
    $self->insert_multi($hash_list);
  }

  sub get_row_by_id {
    args_pos my $self, my $id => 'Int';
    $self->select({id => $id})->first_with_option;
  }

  sub get_row_by_name {
    args_pos my $self, my $name => 'Str';
    $self->select({name => $name})->first_with_option;
  }

  # 結果を park map の marker のための json にするので、 先に何らかのメソッドで結果を取得しておくこと
  sub to_json_for_marker {
    my $self = shift;
    return '[]' unless $self->result;
    "[ " . (join ", ", map { $_->to_json_for_marker } $self->result->all) . " ]";
  }

}

1;

