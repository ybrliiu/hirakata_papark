package HirakataPapark::Model::Role::MultilingualDelegator {

  use Mouse::Role;
  use HirakataPapark;

  use Smart::Args ();

  has 'db' => (
    is       => 'ro',
    isa      => 'HirakataPapark::DB',
    required => 1,
  );

  has 'lang_to_model_table' => (
    is      => 'ro',
    isa     => 'HashRef[Str]',
    builder => '_build_lang_to_model_table',
  );

  # attributes
  requires qw( model_instances );

  # methods
  requires qw( _build_lang_to_model_table );

  sub model {
    Smart::Args::args_pos my $self, my $lang => 'HirakataPapark::lang';
    my $model_instances = $self->model_instances;
    return $model_instances->{$lang} if exists $model_instances->{$lang};
    $model_instances->{$lang} = $self->lang_to_model_table->{$lang}->new(db => $self->db);
  }

}

1;

