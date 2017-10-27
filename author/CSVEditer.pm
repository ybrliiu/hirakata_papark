package CSVEditer {

  use lib './lib';
  use Mouse;
  use HirakataPapark;

  use Path::Tiny;
  use Data::Dumper;
  use Encode;
  use Encode::Guess qw( Shift_jis utf8 );
  use Text::CSV_XS;

  has 'columns'        => ( is => 'ro', isa => 'ArrayRef', required => 1 );
  has 'get_file_name'  => ( is => 'ro', isa => 'Str',      required => 1 );
  has 'save_file_name' => ( is => 'ro', isa => 'Str',      required => 1 );

  sub get_csv_data($self) {
    open my $fh, '<', $self->get_file_name;
    my $parser = Text::CSV_XS->new({
      binary       => 1,
      always_quote => 1,
    });
    my @park_data;
    while (my $columns = $parser->getline($fh)) {
      my %park;
      @park{$self->columns->@*} = map {
        if ($_) {
          my $enc = guess_encoding($_)->name;
          $enc eq 'Shift_jis' ? Encode::decode('Shift_jis', $_) : $_;
        } else {
          $_;
        }
      } @$columns;
      push @park_data, \%park;
    }
    $fh->close;
    \@park_data;
  }
  
  sub save_csv_data($self, $park_data) {
    my @data = map {
      my %park = %{$_};
      join(',', map { qq{"$park{$_}"} } $self->columns->@*) . "\n";
    } @$park_data;
    Path::Tiny::path($self->save_file_name)->touch->spew(\@data);
  }
  
  __PACKAGE__->meta->make_immutable;

}

1;

