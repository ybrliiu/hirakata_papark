package Test::HirakataPapark::Container::TestData {

  use Moose;
  use Bread::Board;
  use HirakataPapark;

  extends qw( Bread::Board::Container );

  has 'name' => ( is => 'ro', isa => 'Str', default => 'TestData' );

  sub declare_park_service($service_name, $park_param) {
    my $param_name = $service_name . '_param';
    service $param_name => $park_param;
    service $service_name => (
      block => sub ($s) {
        my $param = $s->param('param');
        my $parks = $s->param('parks');
        $parks->add_row($param);
        $parks->get_row_by_name($param->{name})->get;
      },
      lifecycle => 'Singleton',
      dependencies => {
        parks => '../../Model/Parks/parks',
        param => $param_name,
      },
    );
  }

  sub BUILD($self, $args) {

    container $self => as {

      container 'Park' => as {

        declare_park_service 'park' => {
          x       => 0.0000,
          y       => 1.3030,
          name    => 'ほげ公園',
          area    => 1000,
          zipcode => '777-7777',
          address => 'A市B町20',
        };

        declare_park_service 'park2' => {
          x       => 111.0000,
          y       => 13.3030,
          name    => 'ぞのはな',
          area    => 10000,
          zipcode => '888-7777',
          address => 'A市C町500',
        };

        declare_park_service 'park3' => {
          x       => 30.0000,
          y       => 111.3030,
          name    => '空き地公園',
          area    => 1,
          zipcode => '888-9999',
          address => 'A市D町0',
        };

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
            $equipments->get_row($param->{park_id}, $param->{name})->get;
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
            $equipments->get_row($param->{park_id}, $param->{name})->get;
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
            $plants->get_row($param->{park_id}, $param->{name})->get;
          },
          lifecycle => 'Singleton',
          dependencies => {
            param  => 'plants_param',
            plants => '../../Model/Parks/plants',
          },
        );

        service 'surrounding_facility_param' => (
          block => sub ($s) {
            my $park = $s->param('park');
            {
              park_id  => $park->id,
              name     => '駐車場',
            };
          },
          lifecycle => 'Singleton',
          dependencies => ['park'],
        );

        service 'surrounding_facility' => (
          block => sub ($s) {
            my $param  = $s->param('param');
            my $sf     = $s->param('surrounding_facilities');
            $sf->add_row($param);
            $sf->get_row($param->{park_id}, $param->{name})->get;
          },
          lifecycle => 'Singleton',
          dependencies => {
            param                  => 'surrounding_facility_param',
            surrounding_facilities => '../../Model/Parks/surrounding_facilities',
          },
        );

        service 'star_param' => (
          block => sub ($s) {
            {
              park_id         => $s->param('park')->id,
              user_seacret_id => $s->param('user')->seacret_id,
            };
          },
          lifecycle    => 'Singleton',
          dependencies => {
            park => 'park',
            user => '../User/user',
          },
        );

        service 'star' => (
          block => sub ($s) {
            my $param  = $s->param('param');
            my $sf     = $s->param('stars');
            $sf->add_row($param);
            $sf->get_row_by_park_id_and_user_seacret_id(
              $param->{park_id},
              $param->{user_seacret_id}
            )->get;
          },
          lifecycle => 'Singleton',
          dependencies => {
            param => 'star_param',
            stars => '../../Model/Parks/stars',
          },
        );

      };

      container 'User' => as {

        service 'user_param' => {
          name     => '市民A',
          id       => 'citizen_A',
          password => 'hogerahogera',
        };

        service 'user' => (
          block => sub ($s) {
            my $param = $s->param('param');
            my $users = $s->param('users');
            $users->add_row($param);
            $users->get_row_by_id($param->{id})->get;
          },
          lifecycle => 'Singleton',
          dependencies => {
            param => 'user_param',
            users => '../../Model/Users/users',
          },
        );

      };

      container 'Web' => as {

        service 'upload' => (
          block => sub ($s) {
            require Mojo::Asset::Memory;
            require Mojo::Upload;
            Mojo::Upload->new(
              asset    => Mojo::Asset::Memory->new,
              filename => 'park_image.png',
            );
          },
          lifecycle => 'Singleton',
        );

      };

    };

  }

  __PACKAGE__->meta->make_immutable;

}

1;

