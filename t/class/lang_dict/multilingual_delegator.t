use HirakataPapark 'test';
use HirakataPapark::Class::LangDict::MultilingualDelegator;

my $delegator;
lives_ok {
  $delegator = HirakataPapark::Class::LangDict::MultilingualDelegator->new;
};
my $ja_dict;
lives_ok { $ja_dict = $delegator->lang_dict('ja') };
is $ja_dict->get('name'), '名前';
dies_ok { $ja_dict->get('AAAAAA!!!!') };
my $en_dict;
lives_ok { $en_dict = $delegator->lang_dict('en') };
is $en_dict->get('name'), 'Name';
dies_ok { $en_dict->get('AAAAAA!!!!') };

done_testing;

