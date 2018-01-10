package HirakataPapark::Container::Model {

  use Mouse;
  use Bread::Board;
  use HirakataPapark;
  use Module::Load qw( load );
  extends qw( Bread::Board::Container );

  has 'name' => ( is => 'ro', isa => 'Str', default => 'Model' );

  with 'HirakataPapark::Role::Singleton';

  sub BUILD($self, $args) {
    container $self => as {

      for my $pkg_name (
        qw(
          HirakataPapark::Model::Users::Users
          HirakataPapark::Model::Parks::Comments
          HirakataPapark::Model::Parks::Images
          HirakataPapark::Model::Parks::Stars
          HirakataPapark::Model::Parks::Tags
          HirakataPapark::Model::MultilingualDelegator::Parks::Parks
          HirakataPapark::Model::MultilingualDelegator::Parks::Plants
          HirakataPapark::Model::MultilingualDelegator::Parks::Equipments
          HirakataPapark::Model::MultilingualDelegator::Parks::SurroundingFacilities
        )
      ) {
        load $pkg_name;

        service $pkg_name => (
          block => sub ($s) { $pkg_name->new(db => $s->param('db')) },
          lifecycle    => 'Singleton',
          dependencies => {db => '../DB/psql'},
        );
      }
      
    };
  }

  __PACKAGE__->meta->make_immutable;

}

1;

