package HirakataPapark::Service::Build::TranslateLangDictToJSONAndSave::JobRunner {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Util qw( to_kebab_case );
  use HirakataPapark::Model::MultilingualDelegator::LangDict::Park::Equipments;
  use HirakataPapark::Model::MultilingualDelegator::LangDict::Park::Plants;
  use HirakataPapark::Model::MultilingualDelegator::LangDict::Park::PlantsCategories;
  use HirakataPapark::Model::MultilingualDelegator::LangDict::Park::SurroundingFacilities;
  use HirakataPapark::Service::Build::TranslateLangDictToJSONAndSave::Job;
  use HirakataPapark::Service::Build::TranslateLangDictToJSONAndSave::HistoryManager;

  use constant DEFAULT_JSON_DIR_ROOT => './assets/json/lang-dicts/';

  has 'lang_dict_namespace' => (
    is      => 'ro',
    isa     => 'Str',
    default => 'HirakataPapark::Model::MultilingualDelegator::LangDict::Park',
  );

  # $self->lang_dict_namespace を除いた辞書クラスのリスト
  has 'lang_dict_names' => (
    is      => 'ro',
    isa     => 'ArrayRef[Str]',
    default => sub ($self) {
      [qw( Equipments Plants PlantsCategories SurroundingFacilities )];
    },
  );
  
  has 'json_dir_root' => (
    is      => 'ro',
    isa     => 'Str',
    default => DEFAULT_JSON_DIR_ROOT,
  );

  has 'lang_dict_name_and_json_dir_pairs' => (
    is      => 'ro',
    isa     => 'HashRef[Str]',
    lazy    => 1,
    builder => '_build_lang_dict_name_and_json_dir_pairs',
  );

  has 'history_manager' => (
    is      => 'ro',
    isa     => 'HirakataPapark::Service::Build::TranslateLangDictToJSONAndSave::HistoryManager',
    lazy    => 1,
    builder => '_build_history_manager',
  );

  sub _build_lang_dict_name_and_json_dir_pairs($self) {
    +{
      map {
        my $class_name = $self->lang_dict_namespace . '::' . $_;
        my $json_dir   = $self->json_dir_root . to_kebab_case $_;
        $class_name => $json_dir;
      } $self->lang_dict_names->@*
    }
  }

  sub _build_history_manager($self) {
    HirakataPapark::Service::Build::TranslateLangDictToJSONAndSave::HistoryManager->new(
      json_dir_root => $self->json_dir_root,
    );
  }

  sub run($self) {
    while ( my ($class_name, $json_dir) = each $self->lang_dict_name_and_json_dir_pairs->%* ) {
      my $delegator = $class_name->new;
      my $job = HirakataPapark::Service::Build::TranslateLangDictToJSONAndSave::Job->new(
        from            => $delegator,
        to              => $json_dir,
        history_manager => $self->history_manager,
      );
      $job->run;
    }
    $self->history_manager->save_record;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

JavaScriptで補完する時に使用する辞書ファイルを生成するプログラム
