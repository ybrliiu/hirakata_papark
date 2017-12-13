package HirakataPapark::Class::LangDict::LangDict {

  use Mouse::Role;
  use HirakataPapark;

  # methods
  requires qw( _build_lang_dict );

  has 'lang_dict' => (
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,
    builder => '_build_lang_dict',
  );

  sub get($self, $word) {
    $self->lang_dict->{$word} // Carp::croak "$word is not defined.";
  }

}

1;

