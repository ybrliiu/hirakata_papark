package HirakataPapark::Model::Users::ParkEditHistories::Park::MetaTables {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;
  use HirakataPapark::Class::ISO639_1Translator qw( to_word );

  use constant {
    BODY_TABLE_NAME => 'user_park_edit_history',
    FOREIGN_LANG_TABLE_NAMES_MAPPED_TO_LANG => +{
      map { $_ => 'user_' . to_word($_) . '_park_edit_history' }
          HirakataPapark::Types->FOREIGN_LANGS->@*
    },
  };

  with 'HirakataPapark::Model::Users::ParkEditHistories::MetaTables::HasOne::MetaTables';

  __PACKAGE__->meta->make_immutable;

}

1;
