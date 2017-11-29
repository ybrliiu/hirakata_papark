package HirakataPapark::DB::Row::EnglishParkSurroundingFacilities {

  use Mouse;
  use HirakataPapark;
  extends 'HirakataPapark::DB::Row';

  with 'HirakataPapark::DB::Row::Role::RelatedToParkAndForeignLanguage';

  __PACKAGE__->meta->make_immutable;

}

1;

