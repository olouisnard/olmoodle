% -*- coding: utf-8 -*-
%
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
% function out = olmoodle_DisplayAnswerField (fid, sn)
%
% On input :
%   fid            : file handler for output
%   sn             : a struct with fields
%      sentence       : a string containing the descriptive sentence
%      latex          : the latex name of variable
%      value          : the value of variable
%      unit           : a string containing the unit (void by default)
%      tol            : the relative tolerance on the result (0.05 by default)
%      format         : the way it should be formatted
%      min            : minimum value of the answer in the whole set
%      max            : maximum value of the answer in the whole set
%      points         : number of points attributed to answer
%      opts : a struct with fields
%         DisplayLatexName : whether the LaTeX name is displayed or not
%         DisplayEqualSign : whether an equal sign is displayed after
%                         variable name
%         BreakLine :     not considered here, always break
%                          after question.
%
% On output : out = 0 ;

function out = olmoodle_DisplayAnswerField (fid, sn)

DEFAULT_FORMAT = 'E2' ;

DEFAULT_OPTS = struct('DisplayLatexName', 1) ;


if any(ismissing(sn.format)) || isempty(sn.format) || ~isfield(sn, 'format')
  sn.format = DEFAULT_FORMAT ;
end

if isempty(sn.sentence) || any(ismissing(sn.sentence))
  sn.sentence = ' ' ;
end

%----------------------------------------------------------------------
% Display sentence and variable latex name
%----------------------------------------------------------------------
fprintf(fid, '%s : $', sn.sentence) ;

% Latex name, if required
if sn.opts.DisplayLatexName
  fprintf(fid, '%s ', sn.latex) ;

  % Equal sign, if required
  if sn.opts.DisplayEqualSign
    fprintf(fid, '= ') ;
  end
end

fprintf(fid, '$ \n') ;

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
  tmp = 0;
 otherwise
end

fprintf(fid, '\n') ;
fprintf(fid, '\n') ;

% Breakline
% $$$ if sn.opts.BreakLine
% $$$   fprintf(fid, '\n') ;
% $$$ end

out = 0 ;
