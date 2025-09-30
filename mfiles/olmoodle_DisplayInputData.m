% -*- coding: utf-8 -*-
%
% OLMOODLE_DISPLAYINPUTDATA :
%
% Displays  a sentence informative on input data of the problem, typically
%
% Sentence latex-symbol : N.NN unit
%
% Usage :
%
% 
%
% On input :
%   fid : file handler for output
%
%   sn  : a struct with the following fields :
%      sentence       : the sentence to be displayed
%      latex          : the latex name of variable
%      value          : the value of variable
%      format         : the way it should be formatted
%      unit           : the unit of variable
%      opts : a struct with fields
%         DisplayLatexName : whether the LaTeX name is disaplyed or not
%         DisplayEqualSign : whether an equal sign is displayed after
%                         variable name
%         BreakLine :        whether a breakline is inserted before
%                         next line or not      
%
% On output : out = 0 ;

function out = olmoodle_DisplayInputData (fid, sn)


DEFAULT_OPTS = struct('BreakLine', 1, ...
		      'DisplayLatexName', 1, ...
		      'DisplayEqualSign', 1 ) ;

DEFAULT_FORMAT = 'E2' ; 


if ~isfield(sn, 'sentence')  ||isempty(sn.sentence) || any(ismissing(sn.sentence))
  sn.sentence = ' ' ;
end

if  ~isfield(sn, 'latex')  || isempty(sn.latex) || any(ismissing(sn.latex))
  sn.latex = '' ;
end

if  ~isfield(sn, 'format') || isempty(sn.format) || any(ismissing(sn.format))
  sn.format = DEFAULT_FORMAT ;
end

if ~isfield(sn, 'opts')  || isempty(sn.opts) || any(ismissing(sn.opts))
  sn.opts = DEFAULT_OPTS ;
end

%----------------------------------------------------------------------
% Format value
%----------------------------------------------------------------------
strvalue = olmoodle_NumberWithPrecision (sn.format, sn.value) ;

%----------------------------------------------------------------------
% Display 
%----------------------------------------------------------------------
%Sentence
fprintf(fid, '%s $', sn.sentence) ;

% fprintf(fid, ' ') ; % French style. We should include that in options

% Latex name, if required
if sn.opts.DisplayLatexName
  fprintf(fid, '%s ', sn.latex) ;
  
  % Equal sign, if required
  if sn.opts.DisplayEqualSign
    fprintf(fid, '= ') ;
  end
  else
end

% Value and unit
fprintf(fid, '%s%s $', strvalue, sn.unit) ;

fprintf(fid, '\n') ;
% Breakline
if sn.opts.BreakLine
  fprintf(fid, '\n') ;
end

out = 0 ;
