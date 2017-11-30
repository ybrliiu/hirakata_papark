package HirakataPapark::Validator::MessageDataDelegator {

  use Mouse::Role;
  use HirakataPapark;
  use Smart::Args ();

  with 'HirakataPapark::Role::Singleton';

  has 'lang_to_data_table' => (
    is      => 'ro',
    isa     => 'HashRef[HirakataPapark::Validator::MessageData]',
    lazy    => 1,
    builder => '_build_lang_to_data_table',
  );

  # methods
  requires qw(
    create_japanese_data
    create_english_data
  );

  sub _build_lang_to_data_table($self) {
    +{
      ja => $self->create_japanese_data,
      en => $self->create_english_data,
    };
  }

  sub message_data {
    Smart::Args::args_pos my $self, my $lang => 'HirakataPapark::lang';
    $self->lang_to_data_table->{$lang};
  }

}

1;

