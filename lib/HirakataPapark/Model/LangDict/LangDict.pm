package HirakataPapark::Model::LangDict::LangDict {

  use Mouse::Role;
  use HirakataPapark;
  use Option;

  # methods
  requires qw( _build_words_dict _build_functions_dict );

  has 'words_dict' => (
    is      => 'ro',
    isa     => 'HashRef[Str]',
    lazy    => 1,
    builder => '_build_words_dict',
  );

  has 'functions_dict' => (
    is      => 'ro',
    isa     => 'HashRef[CodeRef]',
    lazy    => 1,
    builder => '_build_functions_dict',
  );

  sub get_word($self, $keyword) {
    option $self->words_dict->{$keyword};
  }

  sub get_func($self, $keyword) {
    option $self->functions_dict->{$keyword};
  }

}

1;

