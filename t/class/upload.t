use HirakataPapark 'test';
use Mojo::Upload;
use HirakataPapark::Class::Upload;

my $upload;
lives_ok {
  $upload = HirakataPapark::Class::Upload->new(
    upload => Mojo::Upload->new(filename => 'park_image.png'),
  );
};
is $upload->filename_extension, 'png';
is $upload->filename_without_extension, 'park_image';

done_testing;

