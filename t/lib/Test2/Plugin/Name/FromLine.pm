package Test2::Plugin::Name::FromLine;

use strict;
use warnings;
use utf8;
use 5.010001;
use feature ':5.10';
use Test2::API qw( test2_add_callback_context_init );

our $VERSION = '0.01_1';

sub import {
  my ($class, %args) = (shift, @_);
  my $formatter_class = 'Test2::Plugin::Name::FromLine::'
    . ( $args{is_guess_test_line} ? 'GuessTestLineFormatter' : 'Formatter' );
  test2_add_callback_context_init(sub {
    my $ctx = shift;
    callback($ctx, $formatter_class, \%args);
  });
}

sub callback {
  my ($ctx, $formatter_class, $args) = @_;
  my $frame = $ctx->trace->frame;
  # just call from test file. (warning: APIをよく調べる)
  if ($frame->[0] eq 'main') {
    $ctx->hub->format(
        $formatter_class->new({
        line_num  => $frame->[2],
        file_name => $frame->[1],
        %$args,
      })
    );
  }
}

package Test2::Plugin::Name::FromLine::Formatter;

use strict;
use warnings;
use utf8;
use 5.010001;
use feature ':5.10';

use parent qw( Test2::Formatter::TAP );
use Class::Accessor::Lite (
  new => 0,
  ro  => [qw( work_dir file_name file_path file_data line line_num )],
);

use Cwd qw( getcwd );
use Path::Tiny qw( path );

my $WORK_DIR = getcwd;
my %File_cache = ();

sub new {
  my $class = shift;
  my $self = $class->SUPER::new(@_);
  my $args = ref $_[0] eq 'HASH' ? $_[0] : +{@_};
  $self->{work_dir}  = $args->{work_dir}  // $WORK_DIR;
  $self->{file_name} = $args->{file_name} // die "${class} required attribute file_name.";
  $self->{line_num}  = $args->{line_num}  // die "${class} required attribute line_num.";
  $self->{file_path} = $args->{file_path} // $self->work_dir . '/' . $self->file_name;
  $self->{file_data} = $args->{file_data}
    // ( $File_cache{$self->file_name} //= [ split /\n/, path($self->file_path)->slurp ] )
    // die "${class} cannot get file data.";
  $self;
}

sub print_optimal_pass {
  my ($self, $e, $num) = @_;
  # Test2::Formatter::TAP でもこんな感じだったけど
  # 直接オブジェクトのハッシュいじってるけど大丈夫これ?
  if ( $e->isa('Test2::Event::Ok') ) {
    unless ($e->{name}) {
      $e->{name} = "L@{[ $self->line_num ]}: @{[ $self->line ]}";
    }
  }
  $self->SUPER::print_optimal_pass($e, $num);
}

package Test2::Plugin::Name::FromLine::GuessTestLineFormatter;

use strict;
use warnings;
use utf8;
use 5.010001;
use feature ':5.10';

use parent -norequire, qw( Test2::Plugin::Name::FromLine::Formatter );
use Class::Accessor::Lite (
  new => 0,
  ro  => [qw( test_keywords orig_line_num )],
);

my @TEST_KEYWORDS = ('ok ', 'ok\(', 'is ', 'is\(', qw( is_deeply dies_ok lives_ok use_ok ) );

sub new {
  my $class = shift;
  my $self = $class->SUPER::new(@_);
  my $args = ref $_[0] eq 'HASH' ? $_[0] : +{@_};
  $self->{test_keywords} = [ @{ $args->{test_keywords} // [] }, @TEST_KEYWORDS ];
  $self->{orig_line_num} = $self->line_num;
  $self->{line}          = $self->guess_test_line;
  $self;
}

sub guess_test_line {
  my $self = shift;
  my $tmp_line = $self->file_data->[$self->line_num - 1];
  if ( grep { $tmp_line =~ /$_/ } @{ $self->test_keywords } ) {
    $tmp_line;
  } else {
    if ($self->line_num > 0) {
      $self->{line_num} -= 1;
      $self->guess_test_line;
    } else {
      warn "Cannot find test line.";
      $self->orig_line_num;
    }
  }
}

1;

__END__

=encoding utf8

=head1 NAME

Test2::Plugin::Name::FromLine - Auto fill test names

=head1 SYNOPSIS

use Test::More;
use Test2::Plugin::Name::FromLine (is_guess_test_line => 1);

ok (my $vvvvvvvvvvv # auto fill name like: 'ok 1 - L3: ok (my $vvvvvvvvvvv'
  = 100 * 100);

done_testing;

=head1 DESCRIPTION

Test2::Plugin::Name::FromLine is test utility that fills test names from its file.
Just use this module in test and this module fill test names to all test except named one.

=head1 AUTHOR

mp0liiu E<lt>mp0liiu@gmail.com<gt>

=head1 SEE ALSO

This is Test::Name::FromLine.
This is inspired from L<http://subtech.g.hatena.ne.jp/motemen/20101214/1292316676>.

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

