package HirakataPapark::Service::Park::CalcDistance {

  use Mouse;
  use HirakataPapark;
  use Math::Trig qw( deg2rad );

  use constant {
    EQUATORIAL_RADIUS => 637_8137.000, # 赤道半径
    POLAR_RADIUS      => 635_6752.314, # 極半径
  };

  # 第一離心率
  use constant FIRST_ECCENTRICITY => sqrt( ( EQUATORIAL_RADIUS ** 2 - POLAR_RADIUS ** 2 ) / EQUATORIAL_RADIUS ** 2 );
  
  # 子午線曲率半径の分子
  use constant NUMERATOR_OF_MERIDIAN_RADIUS_OF_CURVATURE => (1 - FIRST_ECCENTRICITY ** 2) * EQUATORIAL_RADIUS;

  has 'point1' => ( is => 'ro', does => 'HirakataPapark::Role::Point', required => 1 );
  has 'point2' => ( is => 'ro', does => 'HirakataPapark::Role::Point', required => 1 );

  sub calc($self) {
    my $avarage = deg2rad( ($self->point1->y + $self->point2->y) / 2 );
    my $diff_y  = deg2rad $self->point1->y - $self->point2->y;
    my $diff_x  = deg2rad $self->point1->x - $self->point2->x;
    my $sin     = sin $avarage;
    my $w       = sqrt( 1 - FIRST_ECCENTRICITY ** 2 * $sin ** 2 );
    # 子午線曲率半径
    my $meridian_radius_of_curvature = NUMERATOR_OF_MERIDIAN_RADIUS_OF_CURVATURE / $w ** 3;
    # 卯酉線曲率半径
    my $prime_vertical_radius_of_curvature = EQUATORIAL_RADIUS / $w;
    my $dym = ($diff_y * $meridian_radius_of_curvature) ** 2;
    my $dpa = ($diff_x * $prime_vertical_radius_of_curvature * cos $avarage) ** 2;
    sqrt $dym + $dpa;
  }

  __PACKAGE__->meta->make_immutable;

}

1;

__END__

# ヒュベニの公式 により二点間の距離を求めるservice
# see also
# http://yamadarake.jp/trdi/report000001.html
# http://tancro.e-central.tv/grandmaster/excel/radius.html

