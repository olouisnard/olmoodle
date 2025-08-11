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
% 					      intervalspecs, ...
% 					      points )
%
% On input :
%   fid            : file handler for output
%   sentence       : a string containing the descriptive sentence
%   solutionvalues : the whole set of solutions
%   indexinset     : the index of current solution
%   unit           : a string containing the unit (void by default)
%   tolerance      : the relative tolerance on the result (0.05 by default)
%   intervalspecs : 
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

function out = olmoodle_DisplayAnswerField (fid, sn, ncr, opts )

DEFAULT_FORMAT = 'E2' ;

DEFAULT_OPTS = struct('DisplayLatexName', 1) ;

if nargin < 4 || isempty(opts)
  opts = DEFAULT_OPTS ;
end

if nargin < 3 || isempty(ncr)
  ncr = 1 ;
end

if any(ismissing(sn.format)) || isempty(sn.format) || ~isfield(sn, 'format')
  sn.format = DEFAULT_FORMAT ;
end

if isempty(sn.sentence) || any(ismissing(sn.sentence))
  sn.sentence = ' ' ;
end

%----------------------------------------------------------------------
% Display sentence and variable latex name
%----------------------------------------------------------------------
fprintf(fid, '%s : ', sn.sentence) ;

if opts.DisplayLatexName
  fprintf(fid, '$%s =  $', sn.latex) ;
end

fprintf(fid, '\n') ;

%----------------------------------------------------------------------
% Create latex/numerical environment
%----------------------------------------------------------------------
numericalheaderstartstring = sprintf('\\begin{numerical}[points=%d] \n', sn.points) ;
fprintf(fid, '%s', numericalheaderstartstring) ;

fprintf(fid, '\\item[tolerance={%.10e}] %.10e \n', sn.value * sn.tol, sn.value) ;
fprintf(fid, '\\end{numerical} \n $%s$ \n ', sn.unit) ;

[~, formattype] = olmoodle_NumberWithPrecision (sn.format) ;

  
%----------------------------------------------------------------------
% Displays interval
%----------------------------------------------------------------------
switch formattype
  
 case {'float', 'fixed'}
  % FLOAT or FIXED
  % olmoodle_NumberWithPrecision does the whole formatting business
    
  strmin = olmoodle_NumberWithPrecision (sn.format, sn.min) ;
  strmax = olmoodle_NumberWithPrecision (sn.format, sn.max) ;
    
  fprintf(fid, '$ \\quad (%s \\, \\rightarrow \\, %s) $ ', strmin, strmax) ;

 case 'user'
    % PROVIDED BY USER
    fprintf(fid, '\\quad %s ',sn.format) ;
  
 case 'none'
  % NONE
  tmp=0;
 otherwise
end

fprintf(fid, '\n') ;

%----------------------------------------------------------------------
% Display carriage returns
%----------------------------------------------------------------------
for n = 1 : ncr
  fprintf(fid, '\n') ;
end
