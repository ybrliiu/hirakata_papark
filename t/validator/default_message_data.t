use HirakataPapark 'test';
use HirakataPapark::Validator::DefaultMessageData;

ok my $factory = HirakataPapark::Validator::DefaultMessageData->instance;
ok $factory->message_data('en')->isa('HirakataPapark::Validator::MessageData');
ok $factory->message_data('ja')->isa('HirakataPapark::Validator::MessageData');

done_testing;
