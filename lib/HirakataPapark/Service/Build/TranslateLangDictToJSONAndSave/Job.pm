package HirakataPapark::Service::Build::TranslateLangDictToJSONAndSave::Job {

  use Mouse;
  use HirakataPapark;
  use JSON::XS qw( encode_json );
  use Path::Tiny qw( path );

  has 'from' => (
    is       => 'ro',
    does     => 'HirakataPapark::Model::MultilingualDelegator::LangDict::LangDict',
    required => 1,
  );

  # 言語別のJSONを保存するディレクトリ
  has 'to' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
  );

  has 'history_manager' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Service::Build::TranslateLangDictToJSONAndSave::HistoryManager',
    required => 1,
  );

  has 'json_dir' => (
    is      => 'ro',
    isa     => 'Path::Tiny',
    lazy    => 1,
    builder => '_build_json_dir',
  );

  sub _build_json_dir($self) {
    my $json_dir = path $self->to;
    $json_dir->mkpath unless $json_dir->is_dir;
    $json_dir;
  }

  sub translate_and_save($self, $lang) {
    my $dict = $self->from->lang_dict($lang);
    if ( $self->history_manager->is_class_need_translate(ref $dict) ) {
      path($self->json_dir . "/$lang.json")->spew( encode_json $dict->words_dict );
    }
  }

  sub run($self) {
    for my $lang (HirakataPapark->LANG->@*) {
      $self->translate_and_save($lang);
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;

