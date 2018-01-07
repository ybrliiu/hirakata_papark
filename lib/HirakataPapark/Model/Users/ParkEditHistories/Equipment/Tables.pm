package HirakataPapark::Model::Users::ParkEditHistories::Equipment::Tables {

  use Mouse;
  use HirakataPapark;
  use HirakataPapark::Types;
  use HirakataPapark::Exception;
  use Option;
  use HirakataPapark::Class::ISO639_1Translator qw( to_word );

  use constant {
    BODY_TABLE_NAME           => 'user_park_equipment_edit_history',
    DEFAULT_LANG_TABLE_NAME   => 'user_park_equipment_edit_history_row',
    FOREIGN_LANGS_TABLE_NAMES => +{
      map { $_ => 'user_' . to_word($_) . '_park_plants_edit_history_row' }
        HirakataPapark::Types->FOREIGN_LANGS->@*
    },
  };

  with 'HirakataPapark::Model::Users::ParkEditHistories::Role::Tables';

  sub _build__sc_maker($self) {
    option( HirakataPapark::Types->FOREIGN_LANGS->[0] )->match(
      Some => sub ($lang) { $self->get_select_columns_maker_by_lang($lang) },
      None => sub {
        HirakataPapark::Exception->throw("It's seems to no foreign languages");
      },
    );
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
