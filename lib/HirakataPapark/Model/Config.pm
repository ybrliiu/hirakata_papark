package HirakataPapark::Model::Config {

  use Mouse;
  use HirakataPapark;

  use Option;
  use Config::PL;

  use constant {
    DIR_PATH => 'etc/config/',
    FILES    => [qw/
      db
    /],
  };

  has 'dir_path'     => ( is => 'ro', isa => 'Str', default => DIR_PATH );
  has 'files'        => ( is => 'ro', isa => 'ArrayRef[Str]', default => sub { FILES } );
  has '_config_data' => ( is => 'rw', isa => 'HashRef', init_arg => undef, default => sub { +{} } );

  with 'HirakataPapark::Role::Singleton';

  sub BUILD($self, $args) {
    my @paths = map { $self->dir_path . "$_.conf" } $self->files->@*;
    for my $path (@paths) {
      $self->_config_data(+{
        $self->_config_data->%*,
        config_do($path)->%*,
      })
    }
  }

  sub get_config($self, $key) {
    option $self->_config_data->{$key};
  }

}

1;

=encoding utf8

=head1 NAME
  
  HirakataPapark::Model::Config - 設定値コンテナクラス
                                  アプリケーション中で使用する様々な設定ファイルを読み込み、その設定値を保持、公開するクラス

=head1 SYNOPSIS

  use HirakataPapark::Model::Config;

  my $config = HirakataPapark::Model::Config->singleton;
  my $maybe_db = $config->get('db');
  $maybe_db->map(sub ($c) {
    my $user = $c->{user};
  });

=head1 METHODS

=head2 sub get_config($key: Str) : Option[HashRef]
  
  設定ファイルから読み込んだ設定値を保持したハッシュを外部から参照するメソッド

=cut

