package HirakataPapark::Model::Users::ParkEditHistories::OneToMany::Item::Item {
  
  use Mouse::Role;
  use HirakataPapark;
  use Option ();

  my $Impl = 
    'HirakataPapark::Model::Users::ParkEditHistories::OneToMany::Item::ItemImpl';
  has 'item_impl' => (
    is       => 'ro',
    does     => $Impl,
    handles  => [qw( COLUMN_NAMES lang_records has_all prefix )],
    required => 1,
  );

  # attributes
  requires qw( lang );

  around BUILDARGS => sub ($orig, $self, $item_impl) {
    $self->$orig(item_impl => $item_impl);
  };

  sub AUTOLOAD($self, @args) {
    our $AUTOLOAD;
    my ($method_name) = ($AUTOLOAD =~ /([^:']+$)/);
    $self->_try_delegate_to_item_impl($method_name, \@args);
  }

  sub _try_delegate_to_item_impl($self, $method_name, $args) {
    my $item_impl = $self->item_impl;
    Option::option( $item_impl->can($method_name) )->match(
      Some => sub ($method) { $item_impl->$method(@$args) },
      None => sub { $self->_try_delegate_to_lang_record($method_name) },
    );
  }

  sub _try_delegate_to_lang_record($self, $method_name) {
    my $lang_record = $self->lang_records->${\$self->lang}->get;
    Option::option( $lang_record->can($method_name) )->match(
      Some => sub ($method) { $lang_record->$method()->get },
      None => sub {
        Carp::croak "Can't call method $method_name via package @{[ ref $self ]}.";
      },
    ),
  }

}

1;
