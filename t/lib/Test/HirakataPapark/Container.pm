package Test::HirakataPapark::Container {

  use Moose;
  use Bread::Board;
  use HirakataPapark;

  use Option;
  use Either;
  use IO::Scalar;
  use Module::Load qw( load );
  use Test::HirakataPapark::Container::TestData;

  extends qw( Bread::Board::Container );

  has 'name' => ( is => 'ro', isa => 'Str', default => 'test_hirakata_papark' );

  sub declare_model_services($service_and_pkg_pairs) {
    while ( my ($service_name, $pkg_name) = each %$service_and_pkg_pairs ) {
      service $service_name => (
        block => sub ($s) {
          load $pkg_name;
          $pkg_name->new(db => $s->param('db'));
        },
        lifecycle    => 'Singleton',
        dependencies => {db => '../../DB/db'},
      );
    }
  }

  sub BUILD($self, $args) {

    container $self => as {

      container 'Model' => as {

        container 'MultilingualDelegator' => as {

          declare_model_services +{
            parks => 'HirakataPapark::Model::MultilingualDelegator::Parks::Parks',
          };

        };

        container 'Users' => as {

          declare_model_services +{
            users               => 'HirakataPapark::Model::Users::Users',
            park_edit_histories => 'HirakataPapark::Model::Users::ParkEditHistories::Park',
          };
          
        };

        container 'Parks' => as {

          declare_model_services +{
            tags                   => 'HirakataPapark::Model::Parks::Tags',
            stars                  => 'HirakataPapark::Model::Parks::Stars',
            parks                  => 'HirakataPapark::Model::Parks::Parks',
            plants                 => 'HirakataPapark::Model::Parks::Plants',
            equipments             => 'HirakataPapark::Model::Parks::Equipments',
            english_parks          => 'HirakataPapark::Model::Parks::EnglishParks',
            surrounding_facilities => 'HirakataPapark::Model::Parks::SurroundingFacilities',
          };

          service 'images_save_dir_root' => './t/for_test/park_images';

          service 'images' => (
            block => sub ($s) {
              require HirakataPapark::Model::Parks::Images;
              HirakataPapark::Model::Parks::Images->new(
                db            => $s->param('db'),
                save_dir_root => $s->param('save_dir_root'),
              );
            },
            lifecycle    => 'Singleton',
            dependencies => {
              db            => '../../DB/db',
              save_dir_root => 'images_save_dir_root',
            },
          );

        };

      };

      container 'DB' => as {
        service 'dsn'      => $ENV{TEST_POSTGRESQL};
        service 'username' => $ENV{TEST_POSTGRESQL_USER};
        service 'sql' => (
          block => sub ($s) {
            require HirakataPapark::DB::Schema;
            HirakataPapark::DB::Schema->output
          },
        );
        service 'db' => (
          block => sub ($s) {
            require HirakataPapark::DB;
            require SQL::SplitStatement;
            my $db = HirakataPapark::DB->new(connect_info => [$s->param('dsn'), $s->param('username')]);
            my $splitter = SQL::SplitStatement->new(
              keep_terminator      => 1,
              keep_comments        => 0,
              keep_empty_statement => 0,
            );
            my $dbh = $db->dbh;
            for ( $splitter->split($s->param('sql')) ) {
              $dbh->do($_) || die $dbh->errstr;
            }
            $db;
          },
          lifecycle    => 'Singleton',
          dependencies => [qw/ dsn username sql /],
        );
      };

    };

    $self->add_sub_container(Test::HirakataPapark::Container::TestData->new);

  }

  sub DEMOLISH($self, $is_in_global_destruction) {
    {
      # test db のデータを削除する
      my $dbh = $self->get_sub_container('DB')->get_service('db')->get->dbh;
      my $fh = IO::Scalar->new(\my $anon);
      local *STDERR = $fh;
      $dbh->do('drop schema public cascade;');
      $dbh->do('create schema public;');
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;

