package HirakataPapark::Model::LangDict::Common::En {

  use Mouse;
  use HirakataPapark;

  with 'HirakataPapark::Model::LangDict::LangDict';

  sub _build_words_dict($self) {
    my $data = {
      name                 => 'Name',
      id                   => 'ID',
      password             => 'Password',
      address              => 'Address',
      profile              => 'Profile',
      twitter_id           => 'Twitter ID',
      facebook_id          => 'Facebook ID',
      park_id              => 'Park ID',
      tag_name             => 'Tag Name',
      image_file           => 'Image File',
      site_name            => 'Hirakata Papark',
      park_map             => 'Park Map',
      nearby_parks         => 'Nearby Parks',
      mypage               => 'Your Profile',
      login                => 'Login',
      logout               => 'Logout',
      user_registration    => 'User Registration',
      latitude             => 'Latitude',
      longitude            => 'Longitude',
      area                 => 'Area',
      extent               => 'Extent',
      scenery              => 'Scenery',
      nice                 => 'Nice',
      temp_evacuation_area => 'Temporary evacution area',
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
      login                => 'Login',
      regist_from_twitter  => 'Regist From Twitter',
      map                  => 'Map',
      images               => 'Images',
      post_park_image      => 'Post Park Image',
      select_image         => 'Select Image',
      overview             => 'Overview',
      comments             => 'Comments',
      park_name            => 'park name',
      tag                  => 'Tag',
      equipment            => 'Equipments',
      surrounding_facility => 'Surrounding Facilities',
      search_park          => 'Search Park',
      add_tag              => 'Add Tag',
      tag_list             => 'Tag List',
    };
  }

  sub _build_functions_dict($self) {
    my $words = $self->words_dict;
    +{
      length_func => sub ($min, $max) {
        "Please enter from ${min} to ${max} characters.";
      },
      distance_func => sub ($distance) {
        "Search parks within ${distance}m";
      },
      search_by_func => sub ($key) {
        "$words->{search} By $words->{$key}";
      },
      please_input_func => sub ($key) {
        "Please input @{[ lcfirst $words->{$key} ]}.";
      },
      plants_in_func => sub ($park_name) {
        "$words->{plants} in $park_name";
      },
    };
  }

  __PACKAGE__->meta->make_immutable;

}

1;
