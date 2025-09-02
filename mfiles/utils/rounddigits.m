% ROUNDDIGITS :
%
% Rounds a number to the closest neighbour for the iest position of
% the digit. Method can be one of the 3 functions @round, @floor,
% @ceil. If not specified, @floor is used.
%
% Usage : xround = rounddigits (x, digitpos, fonc)
%
% Examples : 
% --------
%    rounddigits (63.25, 0, @floor) is 63
%    rounddigits (63.25, 1, @floor) is 60
%    rounddigits (63.25, -1, @floor) is 63.2
%    rounddigits (63.25, 0, @ceil) is 64


function xround = rounddigits (x, digitpos, fonc, reverse)

% Argument reverse si convention +/- inversée
if nargin < 4
  reverse = 0 ;
end

if reverse
  digitpos = - digitpos ;
end

% Par défaut on arrondit à l'entier inférieur
if nargin < 3 || isempty(fonc)
  fonc = @floor ;
end

mult =  10^(digitpos) ;
y = x / mult ;


yround = fonc(y) ;

xround = yround * mult ;
