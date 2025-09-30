% OLMOODLE_DISPLAYTEXT
%
% Displays a text.
% Usage :
%
% function out = out = olmoodle_DisplayText (fid, sentence)
%
% On input :
%   fid            : file handler for output
%
%   sn  : a struct with the following fields :
%      sentence       : the sentence to be displayed
%      opts : a struct with fields
%         DisplayLatexName : not considered
%         DisplayEqualSign : not considered
%         BreakLine :        whether a breakline is inserted before
%                         next line or not      
%
% On output : out = 0 ;

function out = olmoodle_DisplayText (fid, sn)

if ~isfield(sn, 'sentence')  ||isempty(sn.sentence) || any(ismissing(sn.sentence))
  sn.sentence = ' ' ;
end

%----------------------------------------------------------------------
% Display sentence
%----------------------------------------------------------------------
fprintf(fid, '%s', sn.sentence) ;

fprintf(fid, '\n') ;

% Breakline
if sn.opts.BreakLine
  fprintf(fid, '\n') ;
end

out = 0 ;
