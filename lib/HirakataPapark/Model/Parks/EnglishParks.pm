package HirakataPapark::Model::Parks::EnglishParks {

  use Mouse;
  use HirakataPapark;
  use Smart::Args qw( args );
  
  use constant {
    TABLE           => 'english_park',
    ORIG_LANG_TABLE => 'park',
  };

  with qw(
    HirakataPapark::Model::Role::DB::ForeignLanguage
    HirakataPapark::Model::Role::DB::Parks::Parks
  );

  sub add_row {
    args my $self, my $id => 'Str',
      my $name    => 'Str',
      my $address => 'Str',
      my $explain => { isa => 'Str', default => '' };

    $self->insert({
      id           => $id,
      english_name => $name,
      address      => $address,
      explain      => $explain,
    });
  }

  around add_rows => sub ($orig, $self, $list) {
    for my $data (@$list) {
      my $name = delete $data->{name};
      $data->{english_name} = $name;
    }
    $self->$orig($list);
  };

  around get_row_by_name => sub ($orig, $self, $name) {
    $self->select({ english_name => $name })->first_with_option;
  };

  around get_rows_like_name => sub ($orig, $self, $name) {
    $self->result_class->new([ $self->select({ english_name => { like => "%${name}%" } })->all ]);
  };

  __PACKAGE__->meta->make_immutable;

}

1;

