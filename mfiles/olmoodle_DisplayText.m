% OLMOODLE_DISPLAYTEXT
%
% Displays a text.
% Usage :
%
% function out = out = olmoodle_DisplayText (fid, sentence)
%
% On input :
%   fid            : file handler for output
%   sentence       : the sentence to be displayed
%
% On output : out = 0 ;

function out = olmoodle_DisplayText (fid, sentence, ncr)

if nargin < 3 || isempty(ncr)
  ncr = 1 ;
end

if nargin < 2 || isempty(sentence) || any(ismissing(sentence))
  sentence = ' ' ;
end

%----------------------------------------------------------------------
% Display sentence
%----------------------------------------------------------------------
fprintf(fid, '%s', sentence) ;
fprintf(fid, '\n') ;

%----------------------------------------------------------------------
% Display carriage returns
%----------------------------------------------------------------------
for n = 1 : ncr
  fprintf(fid, '\n') ;
end


