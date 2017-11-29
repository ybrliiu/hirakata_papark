package HirakataPapark::Model::Role::MultilingualDelegator {

  use Mouse::Role;
  use HirakataPapark;

  use Smart::Args ();

  # attributes
  requires qw( lang_to_model_table model_instances );

  sub model {
    Smart::Args::args_pos my $self,
      my $lang => 'HirakataPapark::lang',
      my $args => { isa => 'HashRef', default => {} };
    my $model_instances = $self->model_instances;
    return $model_instances->{$lang} if exists $model_instances->{$lang};
    $model_instances->{$lang} = $self->lang_to_model_table->{$lang}->new($args);
  }

}

1;

