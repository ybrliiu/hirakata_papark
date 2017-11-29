package HirakataPapark::Model::Role::DB::ForeignLanguage::RelatedToPark {

  use Mouse::Role;
  use HirakataPapark;

  requires qw( TABLE ORIG_LANG_TABLE );

  with 'HirakataPapark::Model::Role::DB::RelatedToPark';

  around PREFETCH_TABLE_NAME => sub ($orig, $self) {
    state $cache = {};
    my $class = ref $self;
    return $cache->{$class} if exists $cache->{$class};
    $cache->{$class} = $self->guess_prefetch_table_name;
  };

  sub guess_prefetch_table_name($self) {
    my $table = $self->db->schema->get_table($self->TABLE);
    my ($prefetch_table_name) =
      map  { $_->reference_table }
      grep { $_->reference_table ne $self->ORIG_LANG_TABLE } $table->get_constraints;
    $prefetch_table_name;
  }

}

1;

