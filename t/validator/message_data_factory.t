use HirakataPapark 'test';
use HirakataPapark::Validator::MessageDataFactory;

ok my $factory = HirakataPapark::Validator::MessageDataFactory->instance;
ok $factory->create_japanese_data->isa('HirakataPapark::Validator::MessageData');
ok $factory->create_english_data->isa('HirakataPapark::Validator::MessageData');

done_testing;
