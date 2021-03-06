use Test::HirakataPapark;
use Test::HirakataPapark::Container;

package TestModel {

  use Mouse;
  use HirakataPapark;
  use Smart::Args;

  use constant {
    LANG                    => 'en',
    BODY_TABLE_NAME         => 'park',
    FOREIGN_LANG_TABLE_NAME => 'english_park',
  };

  with 'HirakataPapark::Model::Role::DB::ForeignLang';

  sub add_row {
    args my $self, my $id => 'Str',
      my $name    => 'Str',
      my $address => 'Str',
      my $explain => { isa => 'Str', default => '' };

    $self->insert({
      id      => $id,
      name    => $name,
      address => $address,
      explain => $explain,
    });
  }

  sub get_row_by_name($self, $name) {
    $self->select({ $self->FOREIGN_LANG_TABLE_NAME . '.name' => $name })->first_with_option;
  }

  __PACKAGE__->meta->make_immutable;

}

my $c     = Test::HirakataPapark::Container->new;
my $db    = $c->get_sub_container('DB')->get_service('db')->get;
my $jpark = $c->get_sub_container('TestData')->get_sub_container('Park')->get_service('park')->get;

ok my $model = TestModel->new(db => $db);
lives_ok {
  $model->add_row({
    id      => $jpark->id,
    name    => 'english_park A',
    address => 'somewhere',
    explain => 'english row test insert',
  })
};

my $epark;
subtest 'select' => sub {
  ok $epark = $model->get_row_by_name('english_park A')->get;
  ok $jpark->isa('HirakataPapark::DB::Row::Park');
  ok $epark->isa('HirakataPapark::DB::Row::EnglishPark');
  is $epark->name, 'english_park A';
  is $epark->zipcode, $jpark->zipcode;
  is $epark->address, 'somewhere';
  is $epark->explain, 'english row test insert';
  is $epark->x, $jpark->x;
  is $epark->y, $jpark->y;
  is $epark->area, $jpark->area;
};

subtest 'update' => sub {
  lives_ok {
    $model->update({ address => 'city A', area => 2000 }, { id => $epark->id });
  };
  my $new_epark;
  lives_ok{ $new_epark = $model->get_row_by_name('english_park A')->get };
  is $new_epark->area, 2000;
  is $new_epark->address, 'city A';
};

done_testing;

