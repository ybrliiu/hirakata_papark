use HirakataPapark 'test';
use Test::HirakataPapark::Container;

package TestModel {

  use Mouse;
  use HirakataPapark;
  use Smart::Args;

  use constant {
    TABLE           => 'english_park',
    ORIG_LANG_TABLE => 'park',
  };

  with 'HirakataPapark::Model::Role::DB::ForeignLanguage';

  sub add_row {
    args my $self, my $id => 'Str',
      my $name    => 'Str',
      my $address => 'Str',
      my $explain => { isa => 'Str', default => '' };

    $self->insert({
      id           => $id,
      english_name => $name,
      address      => $address,
      explain      => $explain,
    });
  }

  sub get_row_by_name($self, $name) {
    $self->join_and_select(english_name => $name)->first_with_option;
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
ok my $epark = $model->get_row_by_name('english_park A')->get;
is $epark->english_name, 'english_park A';
is $epark->address, 'somewhere';
is $epark->explain, 'english row test insert';
is $epark->x, $jpark->x;
is $epark->y, $jpark->y;
is $epark->area, $jpark->area;
is $epark->is_nice_scenery, $jpark->is_nice_scenery;

done_testing;

