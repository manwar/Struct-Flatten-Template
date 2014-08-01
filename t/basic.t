use Test::Most;

use_ok('Struct::Flatten::Template');

my $tmpl = {
    foo => { bar => \{ column => 0, title => 'X' } },
    baz => [ \{ column => 1, indexed => 1, title => 'Y' }, ],
};

my $struct = {
    foo  => { bar => 'a', },
    baz  => [qw/ b c d /],
    boom => 10,
};

my @head;
my @row;

sub handler {
    my ( $obj, $val, $args ) = @_;

    my $col = $args->{column};

    if ( $obj->is_testing ) {

        $head[$col] = $args->{title};

    } else {

        $col += $args->{_index} if $args->{indexed};
        $row[$col] = $val;
    }
}

isa_ok my $p = Struct::Flatten::Template->new(
    handler  => \&handler,
    template => $tmpl,
    ),
    'Struct::Flatten::Template';

$p->test();

is_deeply
    \@head,
    [qw/ X Y /],
    'expected result from test';

$p->run($struct);

is_deeply
    \@row,
    [qw/ a b c d/],
    'expected result from run';

done_testing;
