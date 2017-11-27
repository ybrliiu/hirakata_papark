package HirakataPapark::Service::Park::Searcher::PlantsCategory {

  use Mouse;
  use HirakataPapark;

  has 'name'      => ( is => 'ro', isa => 'Str', required => 1 );
  has 'varieties' => ( is => 'ro', isa => 'ArrayRef[Str]', required => 1 );

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

植物カテゴリオブジェクト
/searcher/plants で使用
