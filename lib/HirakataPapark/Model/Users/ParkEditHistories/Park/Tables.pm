package HirakataPapark::Model::Users::ParkEditHistories::Park::Tables {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;
  use HirakataPapark::Exception;
  use Option;
  use HirakataPapark::Class::ISO639_1Translator qw( to_word );
  use HirakataPapark::Model::Users::ParkEditHistories::Park::SelectColumnsMaker;

  # alias
  use constant SelectColumnsMaker => 
    'HirakataPapark::Model::Users::ParkEditHistories::Park::SelectColumnsMaker';

  use constant {
    BODY_TABLE_NAME           => 'user_park_edit_history',
    FOREIGN_LANGS_TABLE_NAMES => +{
      map { $_ => 'user_' . to_word($_) . '_park_edit_history' }
        HirakataPapark::Types->FOREIGN_LANGS->@*
    },
  };

  has 'foreign_lang_tables' => (
    is      => 'ro',
    isa     => 'HashRef[Aniki::Schema::Table]',
    lazy    => 1,
    builder => '_build_foreign_lang_tables',
  );

  with 'HirakataPapark::Model::Users::ParkEditHistories::Role::Tables';

  sub _build__sc_maker($self) {
    option( HirakataPapark::Types->FOREIGN_LANGS->[0] )->match(
      Some => sub ($lang) { $self->get_select_columns_maker_by_lang($lang) },
      None => sub {
        HirakataPapark::Exception->throw("It's seems to no foreign languages");
      },
    );
  }

  sub _build_foreign_lang_tables($self) {
    my %tables = map {
      my $table_name = $self->FOREIGN_LANGS_TABLE_NAMES->{$_};
      $_ => $self->_table_builder($table_name);
    } HirakataPapark::Types->FOREIGN_LANGS->@*;
    \%tables;
  }

  sub _build_select_columns_makers($self) {
    my %makers = map {
      my $table = $self->foreign_lang_tables->{$_};
      my $sc_maker = SelectColumnsMaker->new({
        table      => $self->body_table,
        join_table => $table,
      });
      $table->name => $sc_maker;
    } HirakataPapark::Types->FOREIGN_LANGS->@*;
    \%makers;
  }

  sub get_select_columns_maker_by_lang($self, $lang) {
    my $table_name = $self->FOREIGN_LANGS_TABLE_NAMES->{$lang};
    $self->select_columns_makers->{$table_name};
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__
