package HirakataPapark::Service::Role::User {

  use Mouse::Role;
  use HirakataPapark;
  use HirakataPapark::DB::Schema;

  {
    # table カラムは全て委譲
    my @fields = HirakataPapark::DB::Schema->context->schema->get_table('user')->get_fields();

    has 'row' => (
      is       => 'ro',
      isa      => 'HirakataPapark::DB::Row',
      handles  => \@fields,
      required => 1,
    );
  }

}

1;

