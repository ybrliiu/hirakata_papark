package Test2::Plugin::Name::FromLine;

use v5.10;
use warnings;
use utf8;
use Test2::API qw( test2_add_callback_context_init );

sub import {
  my ($class, @args) = (shift, @_);
  test2_add_callback_context_init(sub {
    my $ctx = shift;
    callback($ctx, \@args);
  });
}

sub callback {
  my ($ctx, $args) = @_;
  my $frame = $ctx->trace->frame;
  if ($frame->[0] eq 'main') {
    $ctx->hub->format(
      Test2::Plugin::Name::FromLine::Formatter->new({
        line_num  => $frame->[2],
        file_name => $frame->[1],
        @$args,
      })
    );
  }
}

package Test2::Plugin::Name::FromLine::Formatter;

use v5.10;
use warnings;
use utf8;

use parent qw( Test2::Formatter::TAP );
use Class::Accessor::Lite (
  new => 0,
  ro  => [qw( work_dir file_name file_path file_data line_num )],
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
  # 直接オブジェクトのハッシュいじってるけど大丈夫これ?
  if ( $e->isa('Test2::Event::Ok') ) {
    unless ($e->{name}) {
      my $line = $self->file_data->[$self->line_num - 1];
      $e->{name} = "L@{[ $self->line_num ]}: ${line}";
    }
  }
  $self->SUPER::print_optimal_pass($e, $num);
}

1;

