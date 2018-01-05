use Test::HirakataPapark;
use HirakataPapark::Model::MultilingualDelegator::LangDict::Common;

my $delegator;
lives_ok {
  $delegator = HirakataPapark::Model::MultilingualDelegator::LangDict::Common->new;
};
my $ja_dict;
lives_ok { $ja_dict = $delegator->lang_dict('ja') };
is $ja_dict->get_word('name')->get, '名前';
my $en_dict;
lives_ok { $en_dict = $delegator->lang_dict('en') };
is $en_dict->get_word('name')->get, 'Name';
diag $en_dict->get_func('length')->get->(1, 10);
ok $en_dict->get_word('AAAAAA!!!!!')->isa('Option::None');

done_testing;

