package HirakataPapark::DB {

  use Mouse;
  use HirakataPapark;
  extends qw( Aniki );

  use Data::Dumper ();
  use HirakataPapark::DB::Exception;
  use HirakataPapark::DB::DuplicateException;

  override use_strict_query_builder => sub { 0 };

  override handle_error => sub ($self, $sql, $bind, $e) {
    local $Data::Dumper::Maxdepth = 2;
    $sql =~ s/\n/\n          /gm;
    my $exception_class_name =
      'HirakataPapark::DB::' . ( $e =~ /duplicate/ ? 'DuplicateException' : 'Exception' );
    my $bind_str = Data::Dumper::Dumper([
       map { $_ eq '' ? '' : $_->can('value_ref') ? $_->value_ref->$* : $_ } @$bind
    ]);
    $exception_class_name->throw({
      # 先にMojoliciousに例外を検知されて(?)Mojo::Exceptionが来る場合があるので
      # 強制的に文字列化
      message => "$e",
      sql     => $sql,
      bind    => $bind_str,
    });
  };

  __PACKAGE__->setup(
    schema => 'HirakataPapark::DB::Schema',
    filter => 'HirakataPapark::DB::Filter',
    result => 'HirakataPapark::DB::Result',
    row    => 'HirakataPapark::DB::Row',
  );

  __PACKAGE__->meta->make_immutable;

}

1;

