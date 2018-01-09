package HirakataPapark::Model::Users::ParkEditHistories::History::History::HasOne::ToAdd {

  use Mouse;
  use HirakataPapark;
  extends 'HirakataPapark::Model::Users::ParkEditHistories::History::Item::ToAdd';
  with 'HirakataPapark::Model::Users::ParkEditHistories::History::History::History';

  override to_params => sub ($self) {
    my %params = (
      ( map { $self->prefix . $_ => $self->$_ } $self->item_impl->COLUMN_NAMES->@* ),
      ( map { $_ => $self->$_ } $self->COLUMN_NAMES->@* ),
    );
    \%params;
  };

  sub lang_record_to_params($self, $lang, $history_id) {
    $self->lang_records
      ->${\$lang}->get
      ->maybe_to_params($history_id)->get;
  }

  __PACKAGE__->meta->make_immutable;

}

1;
