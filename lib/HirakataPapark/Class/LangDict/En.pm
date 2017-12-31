package HirakataPapark::Class::LangDict::En {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Validator::DefaultMessageData;

  with 'HirakataPapark::Class::LangDict::LangDict';

  my $param = HirakataPapark::Validator::DefaultMessageData
    ->instance->message_data('en')->param;

  sub _build_lang_dict($self) {
    my $data = {
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
      category             => 'Category',
      plants               => 'Plants',
      variety              => 'Variety',
      back                 => 'Back',
      search               => 'Search',
      search_result        => 'Search Result',
      registration         => 'Registration',
      profile              => 'Profile',
      login                => 'Login',
      regist_from_twitter  => 'Regist From Twitter',
      images               => 'Images',
      post_park_image      => 'Post Park Image',
      select_image         => 'Select Image',
      overview             => 'Overview',
      comments             => 'Comments',
      park_name            => 'park name',
      tag                  => 'Tag',
      equipment            => 'Equipments',
      surrounding_facility => 'Surrounding Facility',
      search_park          => 'Search Park',
      length_func          => sub ($min, $max) {
        "Please enter from ${min} to ${max} characters.";
      },
    };
    $data->{search_by_func} = sub ($key) {
      "$data->{search} By $data->{$key}";
    };
    $data->{please_input_func} = sub ($key) {
      "Please input @{[ lcfirst $data->{$key} ]}.";
    };
    $data;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

