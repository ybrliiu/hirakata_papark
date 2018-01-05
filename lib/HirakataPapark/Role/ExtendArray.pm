package HirakataPapark::Role::ExtendArray {

  use Mouse::Role;
  use HirakataPapark;
  use overload (
    '@{}'    => \&to_array,
    fallback => 1,
  );

  # attributes
  requires qw( content );

  around BUILDARGS => sub ($orig, $class, $content) {
    $class->$orig(content => $content);
  };

  sub to_array($self) {
    $self->content->@*;
  }

}

1;
