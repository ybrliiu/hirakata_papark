package HirakataPapark::Service::Park::PostImage::MessageData {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Validator::MessageData;
  use HirakataPapark::Validator::DefaultMessageData;
  
  use constant {
    FILE_SIZE_LIMIT_MB  => 10,
    FILENAME_EXTENSIONS => [qw( png jpg jpeg giff )],
  };

  with 'HirakataPapark::Validator::MessageDataDelegator';

  has 'default_data' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Validator::DefaultMessageData',
    lazy    => 1,
    default => sub ($self) { HirakataPapark::Validator::DefaultMessageData->new },
  );

  sub create_japanese_data($self) {
    my $message_data = $self->default_data->message_data('ja');
    $message_data->{message}{'filename_extension.choice'} =
      '投稿できる画像の種類は、' . join('、', FILENAME_EXTENSIONS->@*) . 'です。';
    $message_data->{message}{file_size} =
      '画像ファイルのサイズの上限は' . FILE_SIZE_LIMIT_MB . 'MB以下です。';
    HirakataPapark::Validator::MessageData->new( $message_data->to_hash );
  }

  sub create_english_data($self) {
    my $message_data = $self->default_data->message_data('en');
    $message_data->{message}{'filename_extension.choice'} =
      'You can post ' . join(', ', FILENAME_EXTENSIONS->@*) . ' image files.';
    $message_data->{message}{file_size} =
      'The upper limit of image file is ' . FILE_SIZE_LIMIT_MB . ' MB.';
    HirakataPapark::Validator::MessageData->new( $message_data->to_hash );
  }

  __PACKAGE__->meta->make_immutable;

}

1;

