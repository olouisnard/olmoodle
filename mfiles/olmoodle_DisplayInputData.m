% OLMOODLE_Displayinputdata
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
%   fid            : file handler for output
%   sn         : a struct with field :
%      sentence       : the sentence to be displayed
%      latex          : the latex name of variable
%      value         : the value of variable
%      unit           : the unit of variable
%
% On output : out = 0 ;

function out = olmoodle_DisplayInputData (fid, sn, ncr, opts)


DEFAULT_OPTS = struct('displayequalsign', 1) ; 
DEFAULT_FORMAT = 'E2' ; 

if nargin < 4 || isempty(opts)
  opts = DEFAULT_OPTS ;
end

if nargin < 3 || isempty(ncr)
  ncr = 1 ;
end

if  ~isfield(sn, 'latex')  || isempty(sn.latex) || any(ismissing(sn.latex))
  sn.latex = '' ;
end

if  ~isfield(sn, 'format') || isempty(sn.format) || any(ismissing(sn.format))
  sn.format = DEFAULT_FORMAT ;
end

if isempty(sn.sentence) || any(ismissing(sn.sentence))
  sn.sentence = ' ' ;
end

%----------------------------------------------------------------------
% Format value
%----------------------------------------------------------------------
strvalue = olmoodle_NumberWithPrecision (sn.format, sn.value) ;

%----------------------------------------------------------------------
% Display 
%----------------------------------------------------------------------
fprintf(fid, '%s $%s',  sn.sentence, sn.latex) ;

% fprintf(fid, ' ') ; % French style. We should include that in options

if opts.displayequalsign
  fprintf(fid, ' = ') ;
end
fprintf(fid, '%s%s $', strvalue, sn.unit) ;

fprintf(fid, '\n') ;

%----------------------------------------------------------------------
% Display carriage returns
%----------------------------------------------------------------------
for n = 1 : ncr
  fprintf(fid, '\n') ;
end


