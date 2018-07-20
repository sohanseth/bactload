function prec = fixPrecision(prec)
% FIXPRECISION fixes a precision vector PREC (sorted by recall) to be monotonic.
%
% Author: Sohan Seth, sseth@inf.ed.ac.uk

prec = flipud(prec);
n = length(prec);
for count = n-1:-1:1
    if prec(count) < prec(count + 1)
        prec(count) = prec(count + 1);
    end
end
prec = flipud(prec);