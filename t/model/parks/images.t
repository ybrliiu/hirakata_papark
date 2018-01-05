use Test::HirakataPapark;
use Test::HirakataPapark::Container;
use Mojo::Upload;
use Mojo::Asset::Memory;
use HirakataPapark::Class::Upload;
use HirakataPapark::Model::Parks::Images;

my $c     = Test::HirakataPapark::Container->new;
my $db    = $c->get_sub_container('DB')->get_service('db')->get;
my $tc    = $c->get_sub_container('TestData');
my $user  = $tc->get_sub_container('User')->get_service('user')->get;
my $park  = $tc->get_sub_container('Park')->get_service('park')->get;
my $model = HirakataPapark::Model::Parks::Images->new(
  db            => $db,
  save_dir_root => './t/for_test/park_images',
);
my $upload = HirakataPapark::Class::Upload->new(
  upload => Mojo::Upload->new(
    asset    => Mojo::Asset::Memory->new,
    filename => 'park_image.png',
  ),
);

subtest add_row => sub {
  my $param = {
    park_id                => $park->id,
    image_file             => $upload,
    posted_user_seacret_id => $user->seacret_id,
    title                  => $upload->filename_without_extension,
  };
  lives_ok { $model->add_row($param) };
  dies_ok { $model->add_row($param) };
};

subtest delete_row => sub {
  my $rows;
  lives_ok { $rows = $model->get_rows_by_park_id($park->id) };
  lives_ok { $model->delete_row($park->id, $rows->[0]->filename_without_extension) };
};

done_testing;
