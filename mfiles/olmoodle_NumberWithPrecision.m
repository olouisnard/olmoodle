% -*- coding: utf-8 -*-
%
% OLMOODLE_NUMBERWITHPRECISION
%
% Requires rounddigits.m
%
% Decode simplified syntax of formatting a number, and produces a string
% ready to display.
%
%
% inputstring : formatting code (string) in the simplified syntax. If
%                 omitted, 'E2' will by taken by default
%
%   Allowed strings in inputstring on input are :
%  
%     'En' : floating point output. n is a positive integer, representing
%             the number of digits after decimal point. The output is
%             a LaTex math string in the form :
%  
%               m.mm 10^pp
%  
%            Note that the dollars are not included, you should take care
%            of that by yourself.
%
%            If n is not present the string character vector '###' is returned
%  
%     'Fz' : fixed point output. z is a positive or negative
%            integer. If positive, it represents the number of digits
%            after decimal point. If negative, decimal part is not
%            displayed and the integer part are padded with 0 (see
%            rounddigits.m). Illustrative examples :
%  
%              olmoodle_NumberWithPrecision ('F2', 1234.567) returns 1234.56
%              olmoodle_NumberWithPrecision ('F-2', 1234.567) returns 1200.
%
%            If n is not present the string character vector '###'
%            is returned
%            The starred version disables printinge the decimal
%            point, whenever z is negative or null. Otherwise this
%            has no effect.
%  
%     'N'  : no display. The null character vector '' is returned
%
%     other : the input string is returned as is
%  
   
function [formattednumber, formattype] = olmoodle_NumberWithPrecision (inputstring, number)

% If number is missing, set to 0
if nargin < 2 ||isempty(number) 
  number = 0. ;
end

% Treat <missing> or empty input strings
if any(ismissing(inputstring)) || isempty(inputstring)
  inputstring = 'E2' ;
end

formatchar = inputstring(1) ;

switch formatchar
 case {'E', 'F'}
  
  
  %  digitstr = extractAfter(inputstring, 1) ;
  % We replace the line above by the following, which allows to
  % find  a numerical substring in strings type Fg12AAA
  tokens = regexp(inputstring, '[^\d]*(\d*)(.*)', 'tokens') ;

  digitstr = tokens{1}{1} ;
  variant  = tokens{1}{2} ;
  
  if isempty(digitstr) || isempty(str2num(digitstr))
    error('Error when parsing input string %s \n Specifiers ''E'' and ''F'' must be followed by an integer.\n', ...
	  inputstring) ;
    formattednumber = '###' ;    
    return
  else 
    ndigit = str2num (digitstr) ;
  end
  otherwise
end


switch formatchar
 case 'E'
  % ------------------------------
  % Floating point
  % ------------------------------
  formattype = 'float' ;
  if ndigit < 0
    warning('Error when parsing input string %s \n', inputstring) ;
    fprintf(1, 'Integer after specifier ''E'' must be positive. \n') ;
    fprintf(1, 'Did you mean ''E%d'' ? I guess so and continue... \n', -ndigit) ;
    return
  end
  formattednumber = decimalform(number, ndigit) ;
 
  case 'F'
   % ------------------------------
   % Fixed point
   % ------------------------------
   formattype = 'fixed' ;
   if ndigit > 0
     % If we want decimals to be displayed (for example code was "F2")
     format_to_use =  sprintf('%%.%df', ndigit) ;
   else
     % If we don't want decimals to be displayed (for example code
     % was "F0" or "F-2"), there are two solutions : either print
     % the (useless) decimal point or not. The latter behaviour is
     % obtained by adding variant *, for example F0*.

     format_to_use =  '%.0f' ;
     if variant == '*'
       format_to_use =  '%.0f' ;
     elseif variant == '.'
       format_to_use =  '%#.0f' ;
     end
   end
   numberrounded = rounddigits(number, ndigit, [], 1) ;
   formattednumber = sprintf (format_to_use, numberrounded) ;

 case 'N'
  % ------------------------------
  % Null string
  % ------------------------------
  formattype = 'none' ;
  formattednumber = '' ;

 otherwise
end
