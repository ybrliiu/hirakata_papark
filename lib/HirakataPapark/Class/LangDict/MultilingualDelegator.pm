package HirakataPapark::Class::LangDict::MultilingualDelegator {

  use Mouse;
  use HirakataPapark;
  use Smart::Args ();
  use HirakataPapark::Class::LangDict::Ja;
  use HirakataPapark::Class::LangDict::En;

  with 'HirakataPapark::Role::Singleton';

  has 'lang_dict_instances_table' => (
    is      => 'ro',
    isa     => 'HashRef[HirakataPapark::Class::LangDict::LangDict]',
    default => sub { +{} },
  );

  has 'lang_dict_class_names_table' => (
    is      => 'ro',
    isa     => 'HashRef[Str]',
    builder => '_build_lang_dict_class_names_table',
  );

  sub _build_lang_dict_class_names_table($self) {
    {
      en => 'HirakataPapark::Class::LangDict::En',
      ja => 'HirakataPapark::Class::LangDict::Ja',
    };
  }

  sub lang_dict {
    Smart::Args::args_pos my $self, my $lang => 'HirakataPapark::lang';
    my $instances_table = $self->lang_dict_instances_table;
    return $instances_table->{$lang} if exists $instances_table->{$lang};
    $instances_table->{$lang} = $self->lang_dict_class_names_table->{$lang}->new;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

