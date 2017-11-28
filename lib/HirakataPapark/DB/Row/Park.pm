package HirakataPapark::DB::Row::Park {

  use Mouse;
  use HirakataPapark;
  extends 'HirakataPapark::DB::Row';

  with 'HirakataPapark::DB::Row::Role::Park';

  __PACKAGE__->meta->make_immutable;

}

1;

