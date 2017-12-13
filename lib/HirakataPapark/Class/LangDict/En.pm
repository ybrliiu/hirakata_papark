package HirakataPapark::Class::LangDict::En {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Validator::DefaultMessageData;

  with 'HirakataPapark::Class::LangDict::LangDict';

  my $param = HirakataPapark::Validator::DefaultMessageData
    ->instance->message_data('en')->param;

  sub _build_lang_dict($self) {
    +{
      %$param,
      address              => 'Address',
      latitude             => 'Latitude',
      longitude            => 'Longitude',
      area                 => 'Area',
      extent               => 'Extent',
      scenery              => 'Scenery',
      nice                 => 'Nice',
      temp_evacuation_area => 'Temporary evacution area',
      name                 => 'Name',
      text_body            => 'Text',
      num                  => 'Num',
      remarks              => 'Remarks',
      details              => 'Details',
      post                 => 'Post',
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;

