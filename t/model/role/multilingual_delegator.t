use HirakataPapark 'test';

package Parks {

  use Mouse;
  use HirakataPapark;

  use HirakataPapark::Model::Parks::Parks;
  use HirakataPapark::Model::Parks::EnglishParks;

  has 'lang_to_model_table' => (
    is      => 'ro',
    isa     => 'HashRef[Str]',
    default => sub ($self) {
      +{
        ja => 'HirakataPapark::Model::Parks::Parks',
        en => 'HirakataPapark::Model::Parks::EnglishParks',
      };
    },
  );

  has 'model_instances' => (
    is      => 'ro',
    isa     => 'HashRef[HirakataPapark::Model::Role::DB::Parks::Parks]',
    default => sub ($self) { +{} },
  );

  with 'HirakataPapark::Model::Role::MultilingualDelegator';

  __PACKAGE__->meta->make_immutable;

}

ok my $delegetor = Parks->new;
ok my $jmodel = $delegetor->model('ja');
ok my $emodel = $delegetor->model('en');
dies_ok { my $model = $delegetor->model('zn') };

done_testing;

