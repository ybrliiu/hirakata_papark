package HirakataPapark::Service::User::Park::ImagePoster::Poster {

  use Mouse;
  use HirakataPapark;
  use Either;
  use Try::Tiny;
  use HirakataPapark::Class::Upload;
  use HirakataPapark::Service::User::Park::ImagePoster::MessageData;
  use HirakataPapark::Service::User::Park::ImagePoster::Validator;

  has 'lang' => ( is => 'ro', isa => 'HirakataPapark::lang', required => 1 );

  has 'user' => (
    is       => 'ro',
    isa      => 'HirakataPapark::DB::Row::User',
    required => 1,
  );

  has 'park_images' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Model::Parks::Images',
    required => 1,
  );

  has 'params' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Validator::Params',
    required => 1,
  );

  has 'maybe_image_file' => (
    is      => 'ro',
    isa     => 'Option::Option',
    lazy    => 1,
    builder => '_build_maybe_image_file',
  );

  has 'message_data' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Validator::MessageData',
    lazy    => 1,
    builder => '_build_message_data',
  );

  has 'validator' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Service::User::Park::ImagePoster::Validator',
    lazy    => 1,
    builder => '_build_validator',
  );

  with 'HirakataPapark::Service::Role::DB';

  sub _build_maybe_image_file($self) {
    $self->params->get('image_file')->map(sub ($image_file) {
      HirakataPapark::Class::Upload->new(upload => $image_file);
    });
  }

  sub _build_message_data($self) {
    HirakataPapark::Service::User::Park::ImagePoster::MessageData
      ->instance->message_data($self->lang);
  }

  sub _build_validator($self) {
    HirakataPapark::Service::User::Park::ImagePoster::Validator->new({
      params       => $self->params,
      message_data => $self->message_data,
    });
  }

  sub BUILD($self, $args) {
    $self->maybe_image_file->foreach(sub ($image_file) {
      $self->params->set(filename_extension => $image_file->filename_extension);
    });
  }

  # -> Either[ Params | Validator | Exception ]
  sub post($self) {
    $self->validator->validate->flat_map(sub {
      my $image_file = $self->maybe_image_file->get;
      $self->params->param('title')->match(
        Some => sub ($title) { $title eq '' ? right $self->params : left '' },
        None => sub { right $self->params },
      )->foreach(sub ($params) {
        $params->set(title => $image_file->filename_without_extension);
      });
      my $txn_scope = $self->txn_scope;
      my $result = try {
        $self->park_images->add_row({
          title                  => $self->params->param('title')->get,
          park_id                => $self->params->param('park_id')->get,
          image_file             => $image_file,
          posted_user_seacret_id => $self->user->seacret_id,
        });
        right 1;
      } catch {
        my $e = $_;
        $txn_scope->rollback;
        left do {
          if ( HirakataPapark::DB::DuplicateException->caught($e)
            && $e->message =~ /filename_without_extension/ ) {
            my $v = $self->validator->validator;
            $v->set_error(image_file => 'already_exist');
            $v;
          } else {
            $e;
          }
        };
      };
      $result->map(sub {
        $txn_scope->commit;
        $self->params;
      });
    });
  }

  __PACKAGE__->meta->make_immutable;

}

1;

