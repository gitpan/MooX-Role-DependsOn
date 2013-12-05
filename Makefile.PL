
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Add a dependency tree to your cows",
  "AUTHOR" => "Jon Portnoy <avenj\@cobaltirc.org>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "MooX-Role-DependsOn",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "MooX::Role::DependsOn",
  "PREREQ_PM" => {
    "List::Objects::Types" => "0.006",
    "List::Objects::WithUtils" => 2,
    "Moo" => 1,
    "MooX::late" => "0.014",
    "Scalar::Util" => 0,
    "Types::TypeTiny" => 0,
    "strictures" => 1
  },
  "TEST_REQUIRES" => {
    "Test::More" => "0.88"
  },
  "VERSION" => "0.001001",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "List::Objects::Types" => "0.006",
  "List::Objects::WithUtils" => 2,
  "Moo" => 1,
  "MooX::late" => "0.014",
  "Scalar::Util" => 0,
  "Test::More" => "0.88",
  "Types::TypeTiny" => 0,
  "strictures" => 1
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



