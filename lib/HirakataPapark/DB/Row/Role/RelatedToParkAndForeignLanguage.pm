package HirakataPapark::DB::Row::Role::RelatedToParkAndForeignLanguage {

  use Mouse::Role;
  use HirakataPapark;
  use SQL::Translator::Schema::Constants;

  sub prefetch_table_name($self) {
    state $cache = {};
    my $class = ref $self;
    return $cache->{$class} if exists $cache->{$class};
    $cache->{$class} = $self->guess_prefetch_table_name;
  }

  sub guess_prefetch_table_name($self) {
    my $table = $self->table;
    my $pk = ($table->primary_key->fields)[0];
    my ($prefetch_table_name) =
      map  { $_->reference_table }
      grep { ($_->fields)[0]->name ne $pk->name } $table->get_constraints;
    $prefetch_table_name;
  }

  sub park($self) {
    my $prefetch_table_name = $self->prefetch_table_name;
    $self->$prefetch_table_name;
  }

}

1;

