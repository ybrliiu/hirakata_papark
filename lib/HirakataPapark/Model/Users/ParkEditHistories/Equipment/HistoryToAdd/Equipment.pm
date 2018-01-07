package HirakataPapark::Model::Users::ParkEditHistories::Equipment::HistoryToAdd::Equipment {
  
  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;

  has 'lang' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Types::Lang',
    init_arg => undef,
    default  => HirakataPapark::Types->DEFAULT_LANG,
  );

  with 'HirakataPapark::Model::Users::ParkEditHistories::Equipment::History::Equipment';

  sub to_params($self, $history_id) {
    my %params = 
      map {; "equipment_$_" => $self->$_ } qw( name comment num recommended_age );
    $params{history_id} = $history_id;
    \%params;
  }

  __PACKAGE__->meta->make_immutable;

}

1;
