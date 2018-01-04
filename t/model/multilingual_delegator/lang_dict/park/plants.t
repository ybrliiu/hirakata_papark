use HirakataPapark 'test';
use HirakataPapark::Model::MultilingualDelegator::LangDict::Park::Plants;

my $delegator;
lives_ok {
  $delegator = HirakataPapark::Model::MultilingualDelegator::LangDict::Park::Plants->new;
};
my $ja_dict;
lives_ok { $ja_dict = $delegator->lang_dict('ja') };
is $ja_dict->get_word('yoshino_cherry')->get, 'ソメイヨシノ';
my $en_dict;
lives_ok { $en_dict = $delegator->lang_dict('en') };
is $en_dict->get_word('oshima_cherry')->get, 'Oshima cherry';
ok $en_dict->get_word('AAAAAA!!!!!')->isa('Option::None');

done_testing;

