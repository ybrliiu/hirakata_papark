package HirakataPapark::Validator::JSON::ParamsContainer {

  use Mouse;
  use HirakataPapark;
  use Option;
  use HirakataPapark::Validator::Params;
  use namespace::autoclean;

  has 'json' => (
    is       => 'ro',
    isa      => 'HashRef',
    required => 1,
  );

  has 'body' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Validator::Params',
    lazy    => 1,
    builder => '_build_body',
  );

  has 'sub_params_mapped' => (
    is      => 'ro',
    isa     => 'HashRef[HirakataPapark::Validator::Params]',
    lazy    => 1,
    builder => '_build_sub_params_mapped',
  );

  sub _build_body($self) {
    my %params = map {
      my ($key, $value) = ($_, $self->json->{$_});
      ref $value eq 'HASH' ? () : ($key => $value);
    } keys $self->json->%*;
    HirakataPapark::Validator::Params->new(\%params);
  }

  sub _build_sub_params_mapped($self) {
    my %params = map {
      my ($key, $value) = ($_, $self->json->{$_});
      if (ref $value eq 'HASH') {
        $key => HirakataPapark::Validator::Params->new($value);
      } else {
        ();
      }
    } $self->json->%*;
    \%params;
  }

  sub get_sub_params($self, $name) {
    option $self->sub_params_mapped->{$name};
  }

  sub sub_params($self) {
    [ values $self->sub_validators_mapped->%* ];
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

=encoding utf8

=head1 DESCRIPTION
  
フォームデータとしてJSONが送られてきた時のValidatorが利用するフォームの値が格納されたクラスです

=cut
