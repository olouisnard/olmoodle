% OLMOODLE_CHECKNUMBER:
%
% Check if an input filed (corresponding to an excel cell is void, if
% it is numeric or not, and if it is integer. 
%
% Void is output whenever either missing, or blank, or made of
% whitespaces or equivalent (as detexted by regexp code \S)

function props = olmoodle_CheckOneField (onecell)

decim = @(x) x - floor(x) ;

props = struct('isvoid',0, ...
		'isnumeric', 0, ...
		'isnotnumeric', 0, ...
		'isinteger', 0) ;

if  anymissing(onecell) || isempty(onecell)
  % Input is void
  props.isvoid = 1 ;

elseif ~isnumeric(onecell)
  %  is not numeric
  IS_BLANK = isempty( regexp(onecell, '\S') ) ;

  % Is it made of blank spaces or equivalent ?
    if IS_BLANK
      props.isvoid = 1 ; % Yes
    else
      props.isnumeric = 0 ; % No
  end

else
  % is numeric
  props.isnumeric = 1 ;

  % We test if furthermore it is integer
  if decim(onecell) == 0 
    % OK it's integer
    props.isinteger = 1 ;
  end
  
end

props.isnotnumeric = ~props.isnumeric ;
