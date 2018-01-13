use Test::HirakataPapark;
use JSON::XS qw( decode_json );
use aliased 'HirakataPapark::Service::User::Park::Editer::ValidatorsContainer';
use aliased 'HirakataPapark::Service::User::Park::Editer::MessageData';

my $json = decode_json '{"id": 0, "sub": {"id": 1}}';
my $container;
lives_ok {
  $container = ValidatorsContainer->new(
    json         => $json,
    message_data => MessageData->instance->message_data('ja'),
  );
};
my $result;
lives_ok { $result = $container->validate };
ok $result->is_left;
$result->left->map(sub ($e) {
  # diag explain $e->errors_and_messages
});

done_testing;
