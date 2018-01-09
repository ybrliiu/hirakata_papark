package HirakataPapark::Model::Users::ParkEditHistories::Equipment::MetaTables {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;
  use HirakataPapark::Exception;
  use HirakataPapark::Class::ISO639_1Translator qw( to_word );

  use constant {
    BODY_TABLE_NAME          => 'user_park_equipment_edit_history',
    DEFAULT_LANG_TABLE_NAME  => 'user_park_equipment_edit_history_row',
    FOREIGN_LANG_TABLE_NAMES_MAPPED_TO_LANG => +{
      map { $_ => 'user_' . to_word($_) . '_park_equipment_edit_history_row' }
          HirakataPapark::Types->FOREIGN_LANGS->@*
    },
  };

  with 'HirakataPapark::Model::Users::ParkEditHistories::MetaTables::HasMany::MetaTables';

  __PACKAGE__->meta->make_immutable;

}

1;
