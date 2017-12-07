package HirakataPapark::DB::DuplicateException {

  use Mouse;
  use HirakataPapark;
  extends 'HirakataPapark::DB::Exception';

  __PACKAGE__->meta->make_immutable;

}

1;

