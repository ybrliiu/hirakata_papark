package HirakataPapark::Model::MultilingualDelegator::LangDict::LangDict {

  use Mouse::Role;
  use HirakataPapark;
  use HirakataPapark::Types;
  use Smart::Args ();

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

  requires qw( _build_lang_dict_class_names_table );

  sub lang_dict {
    Smart::Args::args_pos my $self, my $lang => 'HirakataPapark::Types::Lang';
    my $instances_table = $self->lang_dict_instances_table;
    return $instances_table->{$lang} if exists $instances_table->{$lang};
    $instances_table->{$lang} = $self->lang_dict_class_names_table->{$lang}->new;
  }

}

1;
