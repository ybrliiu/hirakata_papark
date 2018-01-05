package HirakataPapark::Model::Users::ParkEditHistories::Park {

  use Mouse;
  use HirakataPapark;
  use Smart::Args qw( args );

  use Option;
  use HirakataPapark::Exception;

  has 'db' => ( is => 'ro', isa => 'HirakataPapark::DB', required => 1 );

  sub add_history {
    args my $self, my $lang => 'HirakataPapark::lang', 
  }

  sub get_histories_by_park_id($self, $park_id, $num) {
  }

  sub get_histories_by_user_seacret_id($self, $user_seacret_id, $num) {
  }

  __PACKAGE__->meta->make_immutable;

}

1;

=encoding utf8

=head1 DESCRIPTION

ユーザーの公園編集履歴をDBから取得,もしくはDBに格納するモジュールです。
このモジュールではAniki::Rowを返さず、代わりにHistoryオブジェクトを返すので注意して下さい。

=head1 METHODS

=head2 add_history

=cut

