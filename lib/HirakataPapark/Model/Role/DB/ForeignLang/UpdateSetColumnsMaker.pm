package HirakataPapark::Model::Role::DB::ForeignLang::UpdateSetColumnsMaker {

  use Mouse;
  use HirakataPapark;

  has [qw/ body_table foreign_lang_table /] => (
    is       => 'ro',
    does     => 'HirakataPapark::Model::Role::DB::TablesMeta::MetaTable',
    required => 1,
  );

  # カラム名 => 値 のハッシュ
  has 'set' => (
    is       => 'ro',
    isa      => 'HashRef',
    required => 1,
  );

  has 'foreign_lang_table_fields_names' => (
    is      => 'ro',
    isa     => 'ArrayRef[Str]',
    lazy    => 1,
    builder => '_build_foreign_lang_table_fields_names',
  );

  has 'set_of_foreign_lang_table' => (
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,
    builder => '_build_set_of_foreign_lang_table',
  );

  has 'set_of_body_table' => (
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,
    builder => '_build_set_of_body_table',
  );

  sub _build_foreign_lang_table_fields_names($self) {
    [ map { $_->name } $self->foreign_lang_table->get_fields ];
  }

  sub _build_set_of_foreign_lang_table($self) {
    # キー/値のハッシュスライス perl5.20以上
    my %table_sets_includes_undef = %{$self->set}{$self->foreign_lang_table_fields_names->@*};
    my %table_sets = map {
      defined $table_sets_includes_undef{$_} ? ($_ => $table_sets_includes_undef{$_}) : ();
    } keys %table_sets_includes_undef;
    \%table_sets;
  }

  sub _build_set_of_body_table($self) {
    my @body_table_fields_names = map { $_->name } $self->body_table->get_fields;
    my %body_table_sets_includes_undef = %{$self->set}{@body_table_fields_names};
    my %body_table_sets_includes_table_fields = map {
      defined $body_table_sets_includes_undef{$_} ?
        ($_ => $body_table_sets_includes_undef{$_}) : ();
    } keys %body_table_sets_includes_undef;
    if (%body_table_sets_includes_table_fields) {
      my %foreign_lang_table_fields_mapped =
        map { $_ => 1 } $self->foreign_lang_table_fields_names->@*;
      my %body_table_sets = map {
        exists $foreign_lang_table_fields_mapped{$_} ?
          () : ($_ => $body_table_sets_includes_table_fields{$_});
      } keys %body_table_sets_includes_table_fields;
      \%body_table_sets;
    } else {
      \%body_table_sets_includes_table_fields;
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

Model::DB::Role::ForeignLanguage::update での 元の言語のデータが入っているテーブルと外国語テーブルの更新するカラムを求めてくるクラス
カラム名 => 値 ペアが格納されたハッシュを返す

