% STRINGINSIDEBLANKS :
%
% Determines if one can find the pattern string in the input string
% enclosed by only white characters.

function [found, outstr] = StringInsideBlanks (str, pattern)

% We enclose pattern with adequate regexps. Three tokens are
% seeked: a non-blank character on the left of pattern, the
% pattern, and a non-blank character on the right of pattern.
% If pattern is 'findme', we build :
%     (\S*)\s*(findme)\s*(\S*)
regexp_to_find = append('(\S*)\s*(', pattern, ')\s*(\S*)' ) ;

% Let's find the tokens. For strange reasons, regexp returns a cell
% of cells, so that we proceed in two steps.
tmp = regexp(str , regexp_to_find, 'tokens') ;
subregexps = tmp{1} ;

% Here we get a 1x3 cell array. The 1 and 3 components contains
% non-blank strings on the left and on the right, respectively, and
% the 2 component contains the seeked pattern.
%
outstr.left = subregexps{1} ;
outstr.right = subregexps{3} ;
detected_pattern = subregexps{2} ;

if ~strcmp(detected_pattern, pattern)
     fprintf(1, 'Internal problem in StringInsideBlanks \n') ;
     found = 0 ;
end
% The test is therefore positive whenever 1 and 3 are blank and 2 is
% not.
found = isempty(outstr.left) && isempty(outstr.right) ; 

