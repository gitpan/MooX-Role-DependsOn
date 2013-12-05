use Test::More;
use strict; use warnings FATAL => 'all';

{ package
    BareConsumer; use strict; use warnings;
  use Moo;
  with 'MooX::Role::DependsOn';
}

my $nA = BareConsumer->new;
my $nB = BareConsumer->new;
my $nD = BareConsumer->new;
my $nE = BareConsumer->new;

ok !$nA->has_dependencies, '! has_dependencies ok';
$nA->depends_on($nB, $nD);   # A deps on B, D
ok $nA->has_dependencies,  'has_dependencies ok';

my $nC = BareConsumer->new(
  depends_on => [ $nD, $nE ] # C deps on D, E
);

$nB->depends_on($nC, $nE);   # B deps on C, E

my @deplist = $nA->depends_on;
is_deeply \@deplist,
  [ $nB, $nD ],
  'depends_on list ok'
    or diag explain \@deplist;

my @result = $nA->dependency_schedule;

is_deeply \@result,
  [ $nD, $nE, $nC, $nB, $nA ],
  'simple deps resolved ok'
    or diag explain \@result;

# resolved node cb:
my $count = 0;
my $cb = sub {
  my ($root, $node, $resolved, $queued) = @_;
  ok $root == $nA,                       'cb first arg ok';
  ok $node->does('MooX::Role::DependsOn'),  'cb second arg ok';
  ok ref $resolved eq 'ARRAY',              'cb third arg ok';
  ok ref $queued eq 'ARRAY',            'cb fourth arg ok';
  $count++
};
@result = $nA->dependency_schedule(
  callback => $cb
);
ok $count == 5, 'callback called 5 times' or diag $count;
is_deeply \@result,
  [ $nD, $nE, $nC, $nB, $nA ],
  'simple with callback resolved ok'
    or diag explain \@result;

eval {; $nA->dependency_schedule(callback => 'foo') };
like $@, qr/Expected/, 'bad callback dies ok';

# circular dep:

$nD->depends_on($nB);  # D deps on B, B deps on C, C deps on D
eval {; $nA->dependency_schedule };
like $@, qr/Circular dependency/, 'circular dep died ok';

ok $nD->clear_dependencies, 'clear_dependencies ok';
ok !$nD->has_dependencies,  'cleared dependencies';

eval {; $nD->depends_on(foo => 1) };
ok $@, 'bad depends_on dies ok';

done_testing
