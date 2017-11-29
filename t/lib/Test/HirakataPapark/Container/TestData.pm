package Test::HirakataPapark::Container::TestData {

  use Moose;
  use Bread::Board;
  use HirakataPapark;

  extends qw( Bread::Board::Container );

  has 'name' => ( is => 'ro', isa => 'Str', default => 'TestData' );

  sub BUILD($self, $args) {

    container $self => as {

      container 'Park' => as {

        service 'park_param' => {
          x       => 0.0000,
          y       => 1.3030,
          name    => 'ほげ公園',
          area    => 1000,
          address => 'A市B町20',
        };

        service 'park' => (
          block => sub ($s) {
            my $param = $s->param('param');
            my $parks = $s->param('parks');
            $parks->add_row($param);
            $parks->get_row_by_name($param->{name})->get;
          },
          lifecycle => 'Singleton',
          dependencies => {
            parks => '../../Model/Parks/parks',
            param => 'park_param',
          },
        );

        service 'park2_param' => {
          x       => 111.0000,
          y       => 13.3030,
          name    => 'ぞのはな',
          area    => 10000,
          address => 'A市C町500',
        };

        service 'park2' => (
          block => sub ($s) {
            my $param = $s->param('param');
            my $parks = $s->param('parks');
            $parks->add_row($param);
            $parks->get_row_by_name($param->{name})->get;
          },
          lifecycle => 'Singleton',
          dependencies => {
            parks => '../../Model/Parks/parks',
            param => 'park2_param',
          },
        );

        service 'park3_param' => {
          x       => 30.0000,
          y       => 111.3030,
          name    => '空き地公園',
          area    => 1,
          address => 'A市D町0',
        };

        service 'park3' => (
          block => sub ($s) {
            my $param = $s->param('param');
            my $parks = $s->param('parks');
            $parks->add_row($param);
            $parks->get_row_by_name($param->{name})->get;
          },
          lifecycle => 'Singleton',
          dependencies => {
            parks => '../../Model/Parks/parks',
            param => 'park3_param',
          },
        );

        service 'english_park_param' => (
          block => sub ($s) {
            my $park = $s->param('park');
            {
              id      => $park->id,
              name    => 'Hoge Park',
              address => '20, A City',
            };
          },
          lifecycle => 'Singleton',
          dependencies => ['park'],
        );

        service 'english_park' => (
          block => sub ($s) {
            my $param = $s->param('param');
            my $parks = $s->param('parks');
            $parks->add_row($param);
            $parks->get_row_by_name($param->{name})->get;
          },
          lifecycle => 'Singleton',
          dependencies => {
            parks => '../../Model/Parks/english_parks',
            param => 'english_park_param',
          },
        );

        service 'equipment_param' => (
          block => sub ($s) {
            my $park = $s->param('park');
            {
              park_id => $park->id,
              name    => 'ブランコ',
              num     => 3,
            };
          },
          lifecycle => 'Singleton',
          dependencies => ['park'],
        );

        service 'equipment' => (
          block => sub ($s) {
            my $param      = $s->param('param');
            my $equipments = $s->param('equipments');
            $equipments->add_row($param);
            $equipments->get_row_by_park_id_and_name($param->{park_id}, $param->{name})->get;
          },
          lifecycle => 'Singleton',
          dependencies => {
            param      => 'equipment_param',
            equipments => '../../Model/Parks/equipments',
          },
        );

        service 'equipment2_param' => (
          block => sub ($s) {
            my $park = $s->param('park');
            {
              park_id => $park->id,
              name    => '鉄棒',
            };
          },
          lifecycle => 'Singleton',
          dependencies => ['park'],
        );

        service 'equipment2' => (
          block => sub ($s) {
            my $param      = $s->param('param');
            my $equipments = $s->param('equipments');
            $equipments->add_row($param);
            $equipments->get_row_by_park_id_and_name($param->{park_id}, $param->{name})->get;
          },
          lifecycle => 'Singleton',
          dependencies => {
            param      => 'equipment2_param',
            equipments => '../../Model/Parks/equipments',
          },
        );

        service 'plants_param' => (
          block => sub ($s) {
            my $park = $s->param('park');
            {
              park_id  => $park->id,
              name     => 'ソメイヨシノ',
              category => '桜',
            };
          },
          lifecycle => 'Singleton',
          dependencies => ['park'],
        );

        service 'plants' => (
          block => sub ($s) {
            my $param  = $s->param('param');
            my $plants = $s->param('plants');
            $plants->add_row($param);
            $plants->get_row_by_park_id_and_name($param->{park_id}, $param->{name})->get;
          },
          lifecycle => 'Singleton',
          dependencies => {
            param  => 'plants_param',
            plants => '../../Model/Parks/plants',
          },
        );

      };

    };

  }

  __PACKAGE__->meta->make_immutable;

}

1;

