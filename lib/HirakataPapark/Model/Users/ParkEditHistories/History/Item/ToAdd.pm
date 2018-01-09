package HirakataPapark::Model::Users::ParkEditHistories::History::Item::ToAdd {
  
  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;

  has 'lang' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Types::Lang',
    init_arg => undef,
    default  => HirakataPapark::Types->DEFAULT_LANG,
  );

  with 'HirakataPapark::Model::Users::ParkEditHistories::History::Item::Item';

  sub to_params($self, $history_id) {
    my %params = map {;
      $self->prefix . $_ => $self->$_
    } $self->COLUMN_NAMES->@*;
    $params{history_id} = $history_id;
    \%params;
  }

  __PACKAGE__->meta->make_immutable;

}

1;
