package Test::HirakataPapark::Container {

  use Moose;
  use Bread::Board;
  use HirakataPapark;

  use Option;
  use Either;
  use IO::Scalar;
  use HirakataPapark::DB;
  use Test::HirakataPapark::Container::TestData;

  extends qw( Bread::Board::Container );

  has 'name' => ( is => 'ro', isa => 'Str', default => 'test_hirakata_papark' );

  sub BUILD($self, $args) {

    container $self => as {

      container 'Model' => as {

        container 'Users' => as {

          service 'users' => (
            block => sub ($s) {
              require HirakataPapark::Model::Users::Users;
              HirakataPapark::Model::Users::Users->new(db => $s->param('db'));
            },
            lifecycle    => 'Singleton',
            dependencies => {db => '../../DB/db'},
          );
          
        };

        container 'Parks' => as {

          service 'parks' => (
            block => sub ($s) {
              require HirakataPapark::Model::Parks::Parks;
              HirakataPapark::Model::Parks::Parks->new(db => $s->param('db'));
            },
            lifecycle    => 'Singleton',
            dependencies => {db => '../../DB/db'},
          );

          service 'english_parks' => (
            block => sub ($s) {
              require HirakataPapark::Model::Parks::EnglishParks;
              HirakataPapark::Model::Parks::EnglishParks->new(db => $s->param('db'));
            },
            lifecycle    => 'Singleton',
            dependencies => {db => '../../DB/db'},
          );

          service 'tags' => (
            block => sub ($s) {
              require HirakataPapark::Model::Parks::Tags;
              HirakataPapark::Model::Parks::Tags->new(db => $s->param('db'));
            },
            lifecycle    => 'Singleton',
            dependencies => {db => '../../DB/db'},
          );

          service 'equipments' => (
            block => sub ($s) {
              require HirakataPapark::Model::Parks::Equipments;
              HirakataPapark::Model::Parks::Equipments->new(db => $s->param('db'));
            },
            lifecycle    => 'Singleton',
            dependencies => {db => '../../DB/db'},
          );

          service 'plants' => (
            block => sub ($s) {
              require HirakataPapark::Model::Parks::Plants;
              HirakataPapark::Model::Parks::Plants->new(db => $s->param('db'));
            },
            lifecycle    => 'Singleton',
            dependencies => {db => '../../DB/db'},
          );

          service 'surrounding_facilities' => (
            block => sub ($s) {
              require HirakataPapark::Model::Parks::SurroundingFacilities;
              HirakataPapark::Model::Parks::SurroundingFacilities->new(db => $s->param('db'));
            },
            lifecycle    => 'Singleton',
            dependencies => {db => '../../DB/db'},
          );

          service 'stars' => (
            block => sub ($s) {
              require HirakataPapark::Model::Parks::Stars;
              HirakataPapark::Model::Parks::Stars->new(db => $s->param('db'));
            },
            lifecycle    => 'Singleton',
            dependencies => {db => '../../DB/db'},
          );

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
            require SQL::Translator::Producer::PostgreSQL;
            HirakataPapark::DB::Schema->output
          },
        );
        service 'db' => (
          block => sub ($s) {
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

