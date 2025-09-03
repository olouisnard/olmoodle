% OLMOODLE_READTEXTS:
%
% Reads all text blocks and messages used in the program. The
% latter must be coded in a text file structured by blocks like:
%
% .category.messagecode
% Text line 1 
% Text line 2
% |
% Text line N
%
% The blocks must be separated by blank lines. 
%
% On input:
%
% filename: the name of the text file to read
%
% On output:
%
% textstruct: a structure formatted such that 
%    textstruct.category.messagecode 
% contains the text bloc:
%
% Text line 1 
% Text line 2
% |
% Text line N
function textstruct = olmoodle_ReadTexts (filename)

textstruct = struct() ;

%========================================
% Open file as read only
%========================================
fid = fopen (filename, 'r', 'n', 'UTF-8') ;

%========================================
% Main loop
%========================================
strarray = {};
messlinenumber = 0 ;

while ~feof(fid)   % While not end of file
  line = fgetl(fid) ; % Read current line

  % Determine if line is empty (it may contain whitespaces or tabs)
  EMPTY_LINE = isempty(line) || isempty(regexp(line, '\S')) ;


  if ~EMPTY_LINE
    if line(1) == '.'
      % Detect message structure names type aaa.bbb
      % We store the nested fields names in a character vector
      thefieldsname=line(2:end) ;
      messlinenumber = 0 ;
      strarray={} ;

    else
      % Here we have a text message line that we add to a string array
      messlinenumber = messlinenumber + 1 ;
      strarray{messlinenumber} = line ; 
    end
  else
    % Here we have read a block and we must store it into textstruct.aaa.bbb
    fields = split(thefieldsname, '.') ;   
    textstruct.(fields{1}).(fields{2}) = strarray ;
  end
end
