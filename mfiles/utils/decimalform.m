% DECIMALFORM :
%
% For a number written as m 10^e, returns m and e, and possibly the
% corresponding math latex form string.
%
% Usage : 
%
% Examples : 
% --------


function [texstring, m, e]  = decimalform (x, ndec)

if nargin < 2
  ndec = 2 ; 
end


if floor(ndec) ~= ndec
  fprintf(1, 'ERROR : ndec should be integer \n') ;
  return
end

ISZERO = 0 ;
NEGATIVE = 0 ;

% For each value in input vector x
for n = 1:length(x)
  % Examine sign and zeroitude
  if x(n) < 0
    y = -x(n) ;
    NEGATIVE = 1 ;
  elseif x(n) > 0
    y = x(n) ;
  else 
    ISZERO = 1 ;
  end
  
  if ISZERO
    % Number is zero, we output '0.0'
    texstring{n} = '0.0' ;
  else
    % Number is not zero, we determine exponent and mantissa
    e(n) = floor(log10(y)) ; % Exponent
    m(n) = y / 10^e(n) ; % Mantissa
    
    % Formatter to obtain n.ddd 10^e, where the number of "d" is ndec
    formatter = ['%', num2str(ndec + 3),'.', num2str(ndec), 'f \\, 10^{%d} '] ;
    
    outstring = sprintf( formatter, m(n), e(n)) ;

    if NEGATIVE
      texstring{n} = append('-', outstring) ;
    else
      texstring{n} = outstring ;
    end
  end  
end

if length(x) == 1
  texstring = texstring{1} ;
end

