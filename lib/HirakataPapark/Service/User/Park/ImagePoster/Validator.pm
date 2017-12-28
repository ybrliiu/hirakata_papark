package HirakataPapark::Service::User::Park::ImagePoster::Validator {

  use Mouse;
  use HirakataPapark;
  use Either;
  use HirakataPapark::Service::User::Park::ImagePoster::MessageData;

  # alias
  use constant MessageData =>
    'HirakataPapark::Service::User::Park::ImagePoster::MessageData';

  use constant {
    MAX_TITLE_LEN   => 30,
    FILE_SIZE_LIMIT => MessageData->FILE_SIZE_LIMIT_MB * 1024 ** 2,
  };

  with 'HirakataPapark::Service::Role::Validator';

  around _build_validator => sub ($orig, $self) {
    my $v = $self->$orig();
    $v->load_constraints('File');
    $v;
  };

  sub validate($self) {
    my $v = $self->validator;
    $v->check(
      park_id    => ['NOT_NULL', 'INT'],
      title      => [[LENGTH => (0, MAX_TITLE_LEN)]],
      image_file => ['NOT_NULL', [FILE_SIZE => FILE_SIZE_LIMIT]],
      filename_extension => [
        'NOT_NULL', 
        [CHOICE => MessageData->FILENAME_EXTENSIONS->@*],
      ],
    );
    $v->has_error ? left $v : right $v;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

