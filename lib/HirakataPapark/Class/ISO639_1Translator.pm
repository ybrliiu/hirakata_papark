package HirakataPapark::Class::ISO639_1Translator {

  use HirakataPapark;
  use HirakataPapark::Exception;
  use Exporter qw( import );
  our @EXPORT_OK = qw( to_iso639_2 to_word );

  sub to_iso639_2($iso639_1) {
    state $table = {
      en => 'eng',
      ja => 'jpn',
    };
    $table->{$iso639_1} // HirakataPapark::Exception->throw('not found.');
  }

  sub to_word($iso639_1) {
    state $table = {
      en => 'english',
      ja => 'japanese',
    };
    $table->{$iso639_1} // HirakataPapark::Exception->throw('not found.');
  }

}

1;
