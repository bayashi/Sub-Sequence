package Sub::Sequence;
use strict;
use warnings;
use parent qw/Exporter/;

our $VERSION = '0.01';

our @EXPORT = qw/
    seq
/;

sub seq {
    my ($list, $every, $code) = @_;

    _croak("First arg must ARRAY REF: $list") if ref($list) ne 'ARRAY';
    _croak("Second arg is wrong: $every")     if $every < 1;
    _croak("Third arg must CODE REF: $code")  if ref($code) ne 'CODE';

    my $loop = 0;
    my @result;

    my $last = $#{$list};

    while (1) {
        my $start = $loop * $every;
        last if $start > $last;
        my $end = $start + $every - 1;
        if ($end > $last) { $end = $last; }
        $loop++;
        my $ret = $code->(
            +[ @{$list}[$start .. $end] ],
            $loop,
            $loop * $every - $every
        );
        push @result, $ret;
    }

    return \@result;
}

sub _croak {
    require Carp;
    Carp::croak shift;
}

1;

__END__

=head1 NAME

Sub::Sequence - one line description


=head1 SYNOPSIS

    use Sub::Sequence;

    my @user_id_list = (1..10_000_000);

    seq \@user_id_list, 50, sub {
        my $list = shift;

        my $in_id = join ',', map { int $_; } @{$list};
        # UPDATE table SET status=1 WHERE id IN ($id_cond)
        sleep 1;
    };


=head1 DESCRIPTION

Sub::Sequence provides the function named 'seq'.


=head1 FUNCTIONS

=over 4

=item seq($array_ref, $step_count, \&code)

This function calls C<\&code> with split array. 
Return value is the array reference of return value of C<\&code>.

    use Sub::Sequence;

    my $result = seq [1, 2, 3, 4, 5], 2, sub {
        my ($list, $step, $offset) = @_;
        # ... Do something ...
        return $offset;
    };

    warn $result; # [ 0, 2, 4 ]

=back


=head1 REPOSITORY

Sub::Sequence is hosted on github
<http://github.com/bayashi/Sub-Sequence>


=head1 AUTHOR

Dai Okabayashi E<lt>bayashi@cpan.orgE<gt>


=head1 SEE ALSO

L<Sub::Retry>


=head1 LICENSE

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=cut