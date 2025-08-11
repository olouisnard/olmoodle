% OLMOODLE_DISPLAYANSWERFIELD
%
% Requires rounddigits.m
%
% Displays a question with numerical field to be filled by
% student. This is done by defining a moodle numerical question. The
% output displayed has the typical form :
%
%                         ---------------
% Descriptive sentence = |               |  unit  (min - max)
%                         ---------------
%	    
% The student must enter the correct result in the answer box, to some
% allowed tolerance.
%
% The (min - max) part is optional to give the student an order of
% magnitude of the result expected. The values min and max displayed
% are by default the minimum and maximum values obtained over the
% whole set. This can be changed.  By default, the (min - max) info is
% displayed with a default formatting in scientific notations and 3
% characteristic digits.
%
% Usage :
%
% function out = olmoodle_DisplayAnswerField (fid, ...
% 					      sentence, ...
% 					      solutionvalues, ...
% 					      indexinset, ...
% 					      unit, ...
% 					      tolerance, ...
% 					      interval_specs, ...
% 					      points )
%
% On input :
%   fid            : file handler for output
%   sentence       : a string containing the descriptive sentence
%   solutionvalues : the whole set of solutions
%   indexinset     : the index of current solution
%   unit           : a string containing the unit (void by default)
%   tolerance      : the relative tolerance on the result (0.05 by default)
%   interval_specs : 
%     . if structure, defines how the interval is displayed. The fields should be :
%         'format' : a string
%                    the format, in the sprintf syntax (for
%                    example %e.4 %g3.2 etc, see sprintf
%                    documentation)
%         'roundindex' : an integer
%                    useful in fixed decimal format (typically %g),
%                    specify position from where 0 are padded. For
%                    example if roundindex = 2, values will be 200,
%                    1300, 2100. See rounddigits documentation

%     . if void or 1, default formatting in scientific notations and 3
%       characteristic digits, corresponding to %0.2e
%
%     . if -1, don't display (min - max) info to the student
%
%     . if string, you provide the string yourself (at your own
%        risk!). This may be useful if you want to slightly help the
%        student by giving him a rough order of magnitude.
%
%   points : the number of points attributed to the current question (1 by default)
%
% On output : out = 1 ;

function out = OldDisplayAnswerField (fid, ...
				      sentence, ...
				      solutionvalues, ...
				      indexinset, ...
				      unit, ...
				      tolerance, ...
				      interval_specs, ...
				      points )

%----------------------------------------------------------------------
% If no points specified, set to default
%----------------------------------------------------------------------
if nargin < 8
  points = 1 ;
end

%----------------------------------------------------------------------
% Managing the display of the help interval
%----------------------------------------------------------------------
DISPLAY_INTERVAL = 1 ;
DISPLAY_PROVIDED_INTERVAL = 0 ;
DISPLAY_DEFAUT_INTERVAL = 0 ;

out =[] ;

if nargin < 7 || isempty(interval_specs)
  DISPLAY_DEFAUT_INTERVAL = 1 ;
else

  if isnumeric(interval_specs) 
    % If numeric
    switch interval_specs
     case -1
      DISPLAY_INTERVAL = 0 ;
     case 1
      DISPLAY_DEFAUT_INTERVAL = 1 ;
     otherwise 
      fprintf(1, 'Wrong integer value for interval_specs. I set behaviour to 0' ) ;
      DISPLAY_INTERVAL = 0 ;
      out = -1 ;
    end
  
  elseif ischar(interval_specs) || isstring(interval_specs)
    % If character or string (allows string arguments defined either
    % as "blah blah" or as 'blah blah')

    DISPLAY_DEFAUT_INTERVAL = 0 ;
    DISPLAY_PROVIDED_INTERVAL = 1 ;
    
  elseif isstruct(interval_specs)
    % If structure, everything is set.
  
  else
    % Other => error.
    fprintf(1, 'Wrong type for interval_specs. I set behaviour to 0' ) ;
    DISPLAY_INTERVAL = 0 ;  
    out = -2 ;
  end
end

%----------------------------------------------------------------------
% If no tolerance specified, set to default
%----------------------------------------------------------------------
if nargin < 6 || isempty(tolerance)
  tolerance = 0.05 ;
end

%----------------------------------------------------------------------
% If no unit specified, set to default
%----------------------------------------------------------------------
if nargin < 5 || isempty(unit)
  unit = ' ' ;
end

%----------------------------------------------------------------------
% The correct answer.
%----------------------------------------------------------------------
solutionvalue = solutionvalues (indexinset) ;

%----------------------------------------------------------------------
% Display sentence before answer box
%----------------------------------------------------------------------
fprintf(fid, '%s = \n', sentence) ;
%
%----------------------------------------------------------------------
% Create latex/numerical environment
%----------------------------------------------------------------------
numericalheaderstartstring = sprintf('\\begin{numerical}[points=%d] \n', points) ;
fprintf(fid, '%s', numericalheaderstartstring) ;

fprintf(fid, '\\item[tolerance={%.5e}] %.5e \n ', solutionvalue * tolerance, solutionvalue) ;
fprintf(fid, '\\end{numerical}\\; %s ', unit) ;

%----------------------------------------------------------------------
% Displays interval
%----------------------------------------------------------------------
if DISPLAY_INTERVAL
  % Default
  if DISPLAY_DEFAUT_INTERVAL
    fprintf(fid, '\\quad (%0.2e $-$ %0.2e) \n\n',  min(solutionvalues), max(solutionvalues)) ;
    
  elseif DISPLAY_PROVIDED_INTERVAL
    % Provided
    fprintf(fid, '\\quad %s \n\n',  interval_specs) ;
  
  else
    % Complex formatting withh structure
    intervalstringformat = sprintf ('\\\\quad (%%%s $-$ %%%s) \n\n', interval_specs.format, interval_specs.format) ;
    fprintf(fid, intervalstringformat,  ...
	    rounddigits(min(solutionvalues), interval_specs.roundindex), ...
	    rounddigits(max(solutionvalues), interval_specs.roundindex, @ceil) ) ;
  end
end
