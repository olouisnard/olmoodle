% OLMOODLE_FORMATUNIT:
%
% Transforms simple unit definition such as m.s-1 or m2.s-3 into a
% latex decent formatting. For example,
%     um.s.mol-3.kg-2 degC 
%   yields
%     $ \, \mu \mathrm{m}\,  \mathrm{s}\,  \mathrm{C}^{3}\,  \mathrm{kg}^{-2}\,  \mathrm{^\circ\mathrm{C}} $
%
% The input unit string must be formatted as :
%  
%   xxn.xx-n.xxn
%
% xx represents any unit and n or -n is an integer. 
%
% The separator must exist and can be whichever string other than a
% single point. For example it can be a white space. 
%
% It must NOT be :
%    . a letter, 
%    . a numeric digit, 
%    . a minus symbol. 
%
% It can extend over several characters. For example, to code the
% above example, the following will work (although not really useful).
%
%   xxn )#@ xx-n ()!= xxn
%
% There is no control on the official existence of the input unit or
% of the prefix and they will be formatted as is in the output Latex
% string. If you decide for example that Lo is an existent official
% unit (the "louisnard"), the following will work :
%
%    kLo^2.m-3
%
% which means "squared kilolouisnard per cubic meter".
%
% There are exceptions for special units:
%
%  . degree Celsius must be coded on input as "degC" (case independent)
%     and will apeear on output as °C 
%
%  . degree Fahrenheit must be coded on input as "degF" (case independent) and will apeear on output as °F 
%
%  . percents must be coded as "percent" and wil appear on output as %

%  . all prefix (milli, centi, kilo, Giga, ...) etc can be coded in
%     the standard form (m, c, k, G ...), but there is a special
%     treatment for "micro". Code it as "u" (same as in COMSOL) and it
%     will converted in \micro in the Latex output.
%
% Finally empty strings or <missing> are accepted on input, and will
% be converted into the LaTeX blank $ \, $

function unitstring = olmoodle_FormatUnit (inputstring)

% Trat <missing> or empty input strings
if any(ismissing(inputstring)) || isempty(inputstring)
  unitstring = '\,' ;
  return
end

% Format for outputting latex string
exponentlatexfmt = '^{%s}' ;
blankfmt = '\\, ' ;


%----------------------------------------------------------------------  
%
% We want to cut the input string intp 'xxnn' or 'xx-nn' subfields.
% To do so, we detect the positions of the first and last characters
% of subsstrings containing only a...z or A...Z or 0...9 or -
%
%----------------------------------------------------------------------  
% We search a-z A-Z or -
[inds_start_alphanum, inds_end_alphanum] = regexp(inputstring, '[\w,''\-'']*' ) ;

unitstring = '' ;


% ======================================================================
%
% MAIN LOOP 
%
% ======================================================================
for n = 1 : numel (inds_start_alphanum) 
 
  %----------------------------------------------------------------------  
  %
  % Decode input string
  %
  %----------------------------------------------------------------------  

  % Extract string between one starting letter and the following  
  currentunitblock = inputstring(inds_start_alphanum(n): inds_end_alphanum(n)) ;
  
  % In the latter extract the letters and the numeric part
  indsplit = regexp( currentunitblock, '[\d-]*' ) ;

  % There may be no exponent. In this case, exponent 1 is assumed...
  THERE_IS_NO_EXPONENT = isempty(indsplit) ;
  
  % Extract the unit name
  if THERE_IS_NO_EXPONENT

    % There is no exponent
    letter = currentunitblock ;
    exponent = 1; % Useless because we won't write exponent in
		    % LaTeX output
  else
    % Normal case : exponent is specified
    try
      letter  = extractBefore(currentunitblock, indsplit) ;
    catch ME
      error('Error when parsing unit %s (field %d) \n  You probably forgot a separator between two units.\n', inputstring, n) ;
    end
    try 
      exponentstr = extractAfter(currentunitblock, indsplit-1) ;
    catch ME
      error('Error when parsing unit %s (field %d) \n  You probably forgot a separator between two units.\n', inputstring, n) ;
    end
    
    % Converting exponentstr to signed integer (and detect error if
    % exponent is not numeric)
    exponent = str2num(exponentstr);
    if isempty(exponent)
      error('Error when parsing %s (field %d) \n', inputstring, n) ;
    end    
  end
  
  % Converting exponentstr to signed integer again
  exponentstr = sprintf('%d', exponent) ;

  
  %----------------------------------------------------------------------  
  %
  % Special cases
  %
  %----------------------------------------------------------------------  
  % Treating the case of degree Celsius which should be coded by
  % user as degC (in the COMSOL style...). We must replace degC by
  % ^\circ \mathrm{C}. We authrize degC to be capitalized in
  % whatever fashion.
  CELSIUS = strcmp(lower(letter), 'degc') ;
  if CELSIUS
    letter = '^\circ\mathrm{C}' ;
    letterlatexfmt = '%s' ;
  else
    % Normal case
    letterlatexfmt = ' \\mathrm{%s}' ;
  end


  % Treating the case of degree Fahrenheit similarly. Code is degF
  FAHRENHEIT = strcmp(lower(letter), 'degf') ;
  if FAHRENHEIT
    letter = '^\circ\mathrm{F}' ;
    letterlatexfmt = '%s' ;
  else
    % Normal case
    letterlatexfmt = ' \\mathrm{%s}' ;
  end

  % Treating the case of prefix "micro" that should be coded as u,
  % but we want a Latex display with $\mu$. Thus uxxx should
  % generate $\mu \mathrm{xxx}$.
  MICRO = letter(1) == 'u' ;
  if MICRO
    letter = sprintf ( '\\mu \\mathrm{%s}', letter(2:end) ) ;
    letterlatexfmt = '%s' ;
  end
  
  % Trating the case of percent.
  PERCENT = strcmp(lower(letter), 'percent') ;
  if PERCENT
    letter = '\%' ;
    letterlatexfmt = '%s' ;
  end

  SI = strcmp(lower(letter), 'degc') ;
  if SI
    letter = '\mathrm{SI}' ;
    letterlatexfmt = '%s' ;
  end

  
  %----------------------------------------------------------------------  
  %
  % Building Latex substring coding the current unit
  %
  %----------------------------------------------------------------------  
   if THERE_IS_NO_EXPONENT
    latexfmt = append(blankfmt,  letterlatexfmt) ;
    currentstring = sprintf( latexfmt, letter) ;
  else
    latexfmt = append(blankfmt,  letterlatexfmt, exponentlatexfmt) ;
    currentstring = sprintf( latexfmt, letter, exponentstr) ;
  end

  %----------------------------------------------------------------------  
  %
  % Appending current Latex substring to output Latex string
  %
  %----------------------------------------------------------------------    
  unitstring = append(unitstring, currentstring) ;
end

% Final LaTeX $
% unitstring = append(unitstring, ' $') ;

