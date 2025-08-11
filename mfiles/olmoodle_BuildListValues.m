% OLMOODLE_BUILDLISTVALUES
%
% Requires rounddigits.m
%
% Builds a list of equireparted random values between a min and a max.
%
% On input :
%   nset       : number of values required
%   minval     : minimum value
%   maxval     : maximum value
%   roundindex : index of digit different from 0 (see rounddigits)
%                For example if roundindex = 2, values will be 200,
%                1300, 2100
% On output :
%   listv      : list of values

function listv = olmoodle_BuildListValues (nset, vmin, vmax, roundindex)

xi = rand(nset, 1) ;

listv = vmin + (vmax - vmin) * xi ;
listv = rounddigits( listv, roundindex, [], 1) ;
