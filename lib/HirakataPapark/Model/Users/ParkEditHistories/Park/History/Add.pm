package HirakataPapark::Model::Users::ParkEditHistories::Park::History::Add {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;
  extends qw( HirakataPapark::Model::Users::ParkEditHistories::Park::History );
    
  has '+lang' => (
    required => 0,
    default  => HirakataPapark::Types->DEFAULT_LANG,
  );

  __PACKAGE__->meta->make_immutable;

}

1;
