package HirakataPapark::Model::Config {

  use HirakataPapark;
  use Config::PL;

  use constant DIR_PATH => 'etc/config/';

  my @CONFIG_FILES = qw(
    db
  );
  my %Config;

  __PACKAGE__->load( @CONFIG_FILES );

  sub load($class, @config_files) {
    for (@config_files) {
      %Config = (
        %Config,
        %{ config_do DIR_PATH . "$_.conf" },
      );
    }
  }

  sub get {
    \%Config;
  }

}

1;

=encoding utf8

=head1 NAME
  
  HirakataPapark::Model::Config - 設定値コンテナクラス
                                  アプリケーション中で使用する様々な設定ファイルを読み込み、その設定値を保持、公開するクラス

=head1 SYNOPSIS

  use HirakataPapark::Model::Config;

  my $config = HirakataPapark::Model::Config;
  $config->{game}{start_year};                # ゲーム開始年

=head1 メソッド
  
=head2 load
  
  設定ファイルが置かれているディレクトリから設定ファイルをロードします。
  このクラスが読み込まれた時に呼ばれます。

=head2 get 
  
  設定ファイルから読み込んだ設定値を保持したハッシュを外部から参照できるようにするメソッド

=cut
