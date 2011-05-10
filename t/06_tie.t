#! perl

BEGIN {
  if( $] < 5.014) {
    eval "use Test::Simple tests => 1;ok(1,'skip tie tests for perl < 5.14');1;";
    exit(0);
  }
}

use Test::Simple tests => 10;

use Data::Dimensions;

ok(1, "loaded");

my $one = Data::Dimensions->new({m=>1});
tie my $two, 'Data::Dimensions', {m=>1};
my $tee = Data::Dimensions->new({m=>1});

# all this stuff is in 01_ as well, it should continue to work.
$one->set = 3;
$two->set = 4;

$tee->set = $one + $two;

ok($tee == 7, "simple addition");

my $fee = Data::Dimensions->new({m=>2});

$fee = $one * $two;

ok($fee == 12, "multiply");

$tee = $fee / $two;

ok($tee == 3, "divide");

eval {
    my $return = $fee + $one;
};
ok($@, "mixing types dies");

eval {
    $fee->set = $one;
};
ok($@, "saving incorrectly dies");

$two = $one;
ok($two->get() == 3, "set via tie");

eval {
  $two = $fee;
};
ok($@, "Setting bad units in tie fails");

eval {
  my $ret = $fee + $two;
};
ok($@, "Mixing type with a tie() fails");

my $x = $one + 4;
ok(1, "odd recursion bug fixed");
