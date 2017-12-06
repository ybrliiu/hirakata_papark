package HirakataPapark::Model::Role::DB::ForeignLanguage::UpdateSetColumnsMaker {

  use Mouse;
  use HirakataPapark;

  has 'select_columns_maker' => (
    is       => 'ro',
    isa      => 'HirakataPapark::Model::Role::DB::ForeignLanguage::SelectColumnsMaker',
    handles  => [qw( table orig_lang_table )],
    required => 1,
  );

  has 'set' => (
    is       => 'ro',
    isa      => 'HashRef',
    required => 1,
  );

  has 'table_fields_names' => (
    is      => 'ro',
    isa     => 'ArrayRef[Str]',
    lazy    => 1,
    builder => '_build_table_fields_names',
  );

  has 'set_of_table' => (
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,
    builder => '_build_set_of_table',
  );

  has 'set_of_orig_lang_table' => (
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,
    builder => '_build_set_of_orig_lang_table',
  );

  sub _build_table_fields_names($self) {
    [ map { $_->name } $self->table->get_fields ];
  }

  sub _build_set_of_table($self) {
    my %table_sets_includes_undef = %{$self->set}{$self->table_fields_names->@*};
    my %table_sets = map {
      defined $table_sets_includes_undef{$_} ? ($_ => $table_sets_includes_undef{$_}) : ();
      # キー/値のハッシュスライス perl5.20以上
    } keys %table_sets_includes_undef;
    \%table_sets;
  }

  sub _build_set_of_orig_lang_table($self) {
    my @orig_lang_table_fields_names = map { $_->name } $self->orig_lang_table->get_fields;
    my %orig_table_sets_includes_undef = %{$self->set}{@orig_lang_table_fields_names};
    my %orig_table_sets_includes_table_fields = map {
      defined $orig_table_sets_includes_undef{$_} ?
        ($_ => $orig_table_sets_includes_undef{$_}) : ();
    } keys %orig_table_sets_includes_undef;
    if (%orig_table_sets_includes_table_fields) {
      my %table_fields_table = map { $_ => 1 } $self->table_fields_names->@*;
      my %orig_table_sets = map {
        exists $table_fields_table{$_} ?
          () : ($_ => $orig_table_sets_includes_table_fields{$_});
      } keys %orig_table_sets_includes_table_fields;
      \%orig_table_sets;
    } else {
      \%orig_table_sets_includes_table_fields;
    }
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

Model::DB::Role::ForeignLanguage::update での 元の言語のデータが入っているテーブルと外国語テーブルの更新するカラムを求めてくるクラス

