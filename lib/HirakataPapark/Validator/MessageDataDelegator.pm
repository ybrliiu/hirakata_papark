package HirakataPapark::Validator::MessageDataDelegator {

  use Mouse::Role;
  use HirakataPapark;

  with 'HirakataPapark::Role::Singleton';

  # methods
  requires qw(
    message_data
    create_japanese_data
    create_english_data
  );

}

1;

