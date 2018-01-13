package HirakataPapark::Validator::JSON::ValidatorsContainer {

  use Mouse::Role;
  use HirakataPapark;
  use Option;
  use Either;
  use HirakataPapark::Exception;
  use HirakataPapark::Validator::JSON::ParamsContainer;
  use namespace::autoclean;

  has 'message_data' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Validator::MessageData',
    required => 1,
  );

  has 'json' => (
    is       => 'ro',
    isa      => 'HashRef',
    required => 1,
  );

  has 'params_container' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Validator::JSON::ParamsContainer',
    lazy     => 1,
    builder  => '_build_params_container',
  );

  has 'body' => (
    is      => 'ro',
    does    => 'HirakataPapark::Validator::Validator',
    lazy    => 1,
    builder => '_build_body',
  );

  has 'sub_validators_mapped' => (
    is      => 'ro',
    isa     => 'HashRef[HirakataPapark::Validator::Validator]',
    lazy    => 1,
    builder => '_build_sub_validators_mapped',
  );

  # methods
  requires qw( validate _build_body _build_sub_validators_mapped );

  sub _build_params_container($self) {
    HirakataPapark::Validator::JSON::ParamsContainer->new(json => $self->json);
  }

  sub get_sub_validator($self, $name) {
    option $self->sub_validators_mapped->{$name};
  }

  sub sub_validators($self) {
    [ values $self->sub_validators_mapped->%* ];
  }

  sub has_error($self) {
    $self->body->has_error || for_yield($self->sub_validators, sub {
      grep { $_->has_error } @_;
    });
  }

  sub errors_and_messages($self) {
    my $messages = $self->body->errors_and_messages;
    while ( my ($key, $value) = each $self->sub_validators_mapped->%* ) {
      warn "$key is already exists on body Validator" if exists $messages->{$key};
      $messages->{$key} = $value->errors_and_messages;
    }
    $messages;
  }

}

1;

__END__

=encoding utf8

=head1 DESCRIPTION
  
フォームデータとしてJSONが送られてきた時のJSONの値を検証するためのクラスです
JSONでデータを送信すれば普通のフォームとは違ってネストしたデータ構造を送りつけることが出来ます
しかしそのようなデータ構造に格納された値を検証することは通常のValidatorではできません

=cut
