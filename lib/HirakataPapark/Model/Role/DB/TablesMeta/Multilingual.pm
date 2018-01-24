package HirakataPapark::Model::Role::DB::TablesMeta::Multilingual {

  use Mouse::Role;
  use HirakataPapark;
  use HirakataPapark::Types;
  use Option;
  use HirakataPapark::Class::ISO639_1Translator qw( to_word );
  use namespace::autoclean;

  has 'foreign_lang_table_name' => (
    is       => 'ro',
    isa      => 'CodeRef',
    required => 1,
  );

  has 'foreign_lang_tables_names_mapped_to_lang' => (
    is      => 'ro',
    isa     => 'HashRef[Str]',
    lazy    => 1,
    builder => '_build_foreign_lang_tables_names_mapped_to_lang',
  );

  with 'HirakataPapark::Model::Role::DB::TablesMeta::TablesMeta';

  # attributes
  requires qw( foreign_lang_tables_mapped_to_lang );

  # methods
  requires qw( join_tables is_column_exists_in_duplicate_columns );

  sub _build_foreign_lang_tables_names_mapped_to_lang($self) {
    my %map = map {
      my $lang = $_;
      $lang => $self->foreign_lang_table_name->(to_word $lang);
    } HirakataPapark::Types->FOREIGN_LANGS->@*;
    \%map;
  }

  sub foreign_lang_tables($self) {
    my @tables = map {
      $self->foreign_lang_tables_mapped_to_lang->{$_};
    } HirakataPapark::Types->FOREIGN_LANGS->@*;
    \@tables;
  }

  sub get_foreign_lang_table_by_lang($self, $lang) {
    option( $self->foreign_lang_tables_mapped_to_lang->{$lang} )->match(
      Some => sub ($table) { $table },
      None => sub { HirakataPapark::Exception->throw("'$lang' table is not found.") },
    );
  }

  sub tables($self) {
    [ $self->body_table, $self->join_tables->@* ];
  }

}

1;

