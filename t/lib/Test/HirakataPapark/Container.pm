package Test::HirakataPapark::Container {

  use Moose;
  use Bread::Board;
  use HirakataPapark;

  use Option;
  use Either;
  use IO::Scalar;
  use HirakataPapark::DB;

  extends qw( Bread::Board::Container );

  has 'name' => ( is => 'ro', isa => 'Str', default => 'test_hirakata_papark' );

  sub BUILD($self, $args) {

    container $self => as {

      container 'Model' => as {

        container 'Parks' => as {

          service 'parks' => (
            block => sub ($s) {
              require HirakataPapark::Model::Parks::Parks;
              HirakataPapark::Model::Parks::Parks->new(db => $s->param('db'));
            },
            lifecycle    => 'Singleton',
            dependencies => {db => '../../DB/db'},
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

      container 'TestData' => as {

        container 'Park' => as {

          service 'park_param' => +{
            x       => 0.0000,
            y       => 1.3030,
            name    => 'ほげ公園',
            area    => 1000,
            address => 'A市B町20',
          };

          service 'park' => (
            block => sub ($s) {
              my $param = $s->param('park_param');
              my $parks = $s->param('parks');
              $parks->add_row($param);
              $parks->get_row_by_name($param->{name})->get;
            },
            lifecycle => 'Singleton',
            dependencies => +{
              parks      => '../../Model/Parks/parks',
              park_param => 'park_param',
            },
          );

        };

      };

    };

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

