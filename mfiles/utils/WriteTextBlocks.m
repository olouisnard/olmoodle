% WRITETEXTBLOCKS:
%
% Write text blocks (array of strings) in a file
% Replacements is a struct containing the characters or character
% vectors to replace and the replacement character :
%
% Usage : out = WriteTextBlocks (fid, TextBlock, Replacements)
%   
% On input :
%
%   fid : file identifier (file must be open before, or set to 1
%      for screen)
%   TextBlock : an array of string. Each component is a single line.
%   Replacements(n).from : character or string to be replaced
%   Replacements(n).to   : character or string substituted to the latter
%
% On output :
%
%   err : 0 if OK, -1 if error.
%

function out = WriteTextBlocks (fid, TextBlock, Replacements)

out = 0 ;

% No replacements by default
if nargin < 3 || isempty(Replacements)
  Replacements = [] ;
end

% Detect type of input
if iscellstr(TextBlock)
  
% Array of strings
  MANY_LINES = 1 ;
  nlines = numel (TextBlock) ;

  for iline = 1:nlines
    linetowrite =TextBlock{iline} ;

    for n = 1 : numel(Replacements)
    linetowrite = strrep( linetowrite, Replacements(n).from, Replacements(n).to) ;
    end
    linetowrite = append( linetowrite, '\n') ;
    fprintf (fid, linetowrite) ;
  end

elseif isstring(TextBlock) || ischar(TextBlock)
  % Simple string
  MANY_LINES = 0 ;
  
  linetowrite = append( TextBlock, '\n') ;
  fprintf (fid, linetowrite) ;
else
  error('Bad block type') ;
  err = -1 ;
end
