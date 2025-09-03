% OLMOODLE_READEXCEL :

function [datastruct, genstruct, errorstruct, errorcodes] = ...
    olmoodle_ReadExcel (xlsfilename, textstruct)



decim = @(x) x - floor(x) ;

% ExcelColumnsStruct
%----------------------------------------------------------------------
% Column numbers in Excel file
%----------------------------------------------------------------------
CCODE = 1 ;
CTEXT = 2 ;
CLATEX = 3 ;
CMATLAB = 4 ;
CMIN = 5 ;
CVAL = 5 ;
CMAX = 6 ;
CPREC = 7 ;
CUNIT = 8 ;
CFORMAT = 9 ;

CNUMBEROFSET = 2 ;
CPOINTS = 5 ;
CTOLERANCE = 5 ;

CHEADER = CTEXT ;
CMOODLECAT = CTEXT ;

%----------------------------------------------------------------------
% Error codes 
%----------------------------------------------------------------------
errorcodes.NSET_BADLY_SPECIFIED = 1 ;
errorcodes.NSET_UNSPECIFIED = 2 ;
errorcodes.NSET_IS_VOID = 8 ;
errorcodes.WRONG_CODE = 3 ;
errorcodes.POINTS_NOT_INTEGER = 4 ;
errorcodes.POINTS_NOT_NUMERIC = 5 ;
errorcodes.TOL_BADLY_SPECIFIED = 6 ; 
errorcodes.TOL_UNSPECIFIED = 7 ; 
errorcodes.TOL_IS_VOID = 9 ; 
errorcodes.PRECISION_NOT_INTEGER = 10 ; 
errorcodes.PRECISION_NOT_NUMERIC = 11 ; 
errorcodes.PRECISION_UNSPECIFIED = 12 ; 
errorcodes.TOL_BAD_UNIT = 13 ; 

%======================================================================
%
% Read Excel file as cell array
%
%======================================================================
opts = detectImportOptions(xlsfilename) ;
% opts = setvaropts(opts, 'Formattage', 'FillValue', {''} ); % A vérifier

tabcells = readcell(xlsfilename, "Range", "A1:I100") ;

% Size of Excel zone read 
[nlines, ncols] = size(tabcells) ;


ktext = 0 ; % Number of text lines 
kvar = 0 ; % Number of variable input lines 
kfixed = 0 ; % Number of fixed input lines 
kcalc = 0 ; % Number of calculated input lines 
kquestion = 0 ; % Number of question lines 

ilin = 0 ;
iok = 0 ;
done = 0 ;

genstruct.lists.varinput = [] ;
genstruct.lists.fixedinput = [] ;
genstruct.lists.calc = [] ;
genstruct.lists.question = [] ;

errorstruct = struct([]) ;
nerrors = 0 ;

NSET_WAS_FOUND = 0 ;
TOL_WAS_FOUND = 0 ;
MOODLECAT_WAS_FOUND = 0 ;
%======================================================================
%
% MAIN LOOP
%
%======================================================================
while ~done    
  ilin  = ilin + 1 ;

  % Extract code in first column of Excel file 
  code = tabcells {ilin, CCODE} ;
  
  % Detect comment
  iscomment = ismissing(code) ;
  
  
  if ~iscomment      
    % If line is not a comment, increment number of active lines and
    % examine code      
    
    switch code 
      
     case 'M'
      %============================================================
      % Moodle category to store questions
      %============================================================
      tmp = tabcells{ilin, CMOODLECAT} ; 
      MOODLECAT_WAS_FOUND = 1 ;

      if any(ismissing(tmp)) || isempty(tmp)
	genstruct.moodlecategory = [] ;     	
      else
	genstruct.moodlecategory = tmp ;     
      end
     
     case 'H'
      %============================================================
      % Header (the title of generated question)
      %============================================================
      tmp = tabcells{ilin, CHEADER} ; 
      if any(ismissing(tmp)) || isempty(tmp)
	genstruct.header = 'Numerical question' ;     	
      else
	genstruct.header = tmp ;     
      end
     
     case 'N'
      %============================================================
      % Number of sets
      %============================================================
      tmp = tabcells{ilin, CNUMBEROFSET} ; 
      NSET_WAS_FOUND = 1 ;

      if  any(ismissing(tmp))
	nerrors = nerrors  + 1 ;
	errorstruct(nerrors).code = errorcodes.NSET_IS_VOID ;
	errorstruct(nerrors).line = ilin ;
      elseif ~isnumeric(tmp)
	nerrors = nerrors  + 1 ;
	errorstruct(nerrors).code = errorcodes.NSET_BADLY_SPECIFIED ;
	errorstruct(nerrors).line = ilin ;
	errorstruct(nerrors).string = tmp  ;
      else
	genstruct.nset = tmp ;     
      end
      
     case 'Z'
      %============================================================
      % Tolerance
      %============================================================
      tolstr = tabcells{ilin, CTOLERANCE} ;    
      TOL_WAS_FOUND = 1 ;
      
      %----------------------------------------
      % Examine if tolerance is correct
      %----------------------------------------
      if  any(ismissing(tolstr)) 
	% Tolerance is void
	nerrors = nerrors  + 1 ;
	errorstruct(nerrors).code = errorcodes.TOL_IS_VOID ;
	errorstruct(nerrors).line = ilin ;
      elseif ~isnumeric(tolstr)
	% Tolerance is not numeric
	nerrors = nerrors  + 1 ;
	errorstruct(nerrors).code = errorcodes.TOL_BADLY_SPECIFIED ;
	errorstruct(nerrors).line = ilin ;
	errorstruct(nerrors).string = tolstr ;
      else
	% Tolerance is OK
	iok = iok + 1 ;
	datastruct(iok).type           = 'tol' ;
	datastruct(iok).props.text     = tabcells{ilin, CTEXT} ;
	datastruct(iok).props.value    = tabcells{ilin, CVAL} ;
	datastruct(iok).props.format   = tabcells{ilin, CFORMAT} ;
	datastruct(iok).props.unit     = tabcells{ilin, CUNIT} ;
	datastruct(iok).props.opts = struct([]) ;

	genstruct.lists.tol = iok ;
	
	%----------------------------------------
	% Examine if unit of tolerance is correct
	%----------------------------------------
	tolunitstr = datastruct(iok).props.unit ;

	
	if isempty(tolunitstr) || any(ismissing(tolunitstr))   % Tolerance unit field is void
        % Tolerance should be understood as is
	  genstruct.tol = datastruct(iok).props.value ;
	  genstruct.tolpercent = genstruct.tol * 100 ;

	else % Tolerance unit field is not void...

	  % ... determine if it is blank 
	  TOLUNITSTR_IS_BLANK = isempty( regexp(tolunitstr, '\S') ) ;

	  if TOLUNITSTR_IS_BLANK
	    % If blank, tolerance should be understood as is
	    genstruct.tol = datastruct(iok).props.value ;
	    genstruct.tolpercent = genstruct.tol * 100 ;
	    
	    
	  elseif StringInsideBlanks(lower(tolunitstr), 'percent')
	    % Check if contains 'percent', possibly enclosed within
	    % blank-like characters
	    genstruct.tolpercent = datastruct(iok).props.value ;
	    genstruct.tol = genstruct.tolpercent / 100 ;
	    
	  else
	    % Otherwise error
	    nerrors = nerrors  + 1 ;
	    errorstruct(nerrors).code = errorcodes.TOL_BAD_UNIT ;
	    errorstruct(nerrors).line = ilin ;
	    errorstruct(nerrors).string = datastruct(iok).props.unit ;
	  end
	end
      end
     
     case 'T'
      %============================================================
      % Pure text
      %============================================================
      iok = iok + 1 ;
      ktext = ktext + 1;

      datastruct(iok).type       = 'text' ;
      datastruct(iok).props.text     = tabcells{ilin, CTEXT} ;
      datastruct(iok).props.position = iok ;
      datastruct(iok).props.opts = struct([]) ;

      genstruct.lists.text(ktext) = iok ;
      
     
     
     case 'V'
      %============================================================
      % Input quantity variable in set
      %============================================================
      iok = iok + 1 ;
      kvar = kvar + 1;
 
      datastruct(iok).type      = 'varinput' ;

      thetext = tabcells{ilin, CTEXT} ;

      if isempty(thetext) || any(ismissing(thetext))
	thetext = ' ' ;
      end
      datastruct(iok).props.text      = thetext ;

      datastruct(iok).props.latex     = tabcells{ilin, CLATEX} ;
      datastruct(iok).props.matlab    = tabcells{ilin, CMATLAB} ;
      datastruct(iok).props.min       = tabcells{ilin, CMIN} ;
      datastruct(iok).props.max       = tabcells{ilin, CMAX} ;
      datastruct(iok).props.unit      = tabcells{ilin, CUNIT} ;
      datastruct(iok).props.format    = tabcells{ilin, CFORMAT} ;
      datastruct(iok).props.position  = iok ;
      datastruct(iok).props.opts = struct([]) ;

      genstruct.lists.varinput(kvar) = iok ;

      %----------------------------------------
      % Detect precision errors
      %----------------------------------------
      precision = tabcells{ilin, CPREC} ;

      if any(ismissing(precision)) || isempty(precision)

	nerrors = nerrors  + 1 ;

	% Void precision field, we set to 0 by default. This is
        % just a warning
	  errorstruct(nerrors).code = errorcodes.PRECISION_UNSPECIFIED ;
	  errorstruct(nerrors).line = ilin ;
      
      else
	% Not void precision field...
	if ~isnumeric(precision)
	  % We test if not numeric
	  nerrors = nerrors  + 1 ;
	  errorstruct(nerrors).code = errorcodes.PRECISION_NOT_NUMERIC ;
	  errorstruct(nerrors).line = ilin ;
	  errorstruct(nerrors).string = precision ;
	  
	else
	  % OK, precision field is indeed a number.
	  % We test if integer
	  if decim(precision) == 0 
	    % OK it's integer, assign precision in datastruct
	    
	    datastruct(iok).props.precision = precision ;

	  else
	    % It's not integer : error
	    nerrors = nerrors  + 1 ;
	    errorstruct(nerrors).code = errorcodes.PRECISION_NOT_INTEGER ;
	    errorstruct(nerrors).line = ilin ;
	    errorstruct(nerrors).string = num2str(precision) ;
	  end
	end 
      end
      
     case 'F'
      %============================================================
      % Input quantity fixed in set
      %============================================================
      iok = iok + 1 ;
      kfixed = kfixed + 1;

      datastruct(iok).type     = 'fixedinput' ;
      
      thetext = tabcells{ilin, CTEXT} ;

      if isempty(thetext) || any(ismissing(thetext))
	thetext = ' ' ;
      end
      datastruct(iok).props.text     = thetext ;
      
      datastruct(iok).props.latex    = tabcells{ilin, CLATEX} ;
      datastruct(iok).props.matlab   = tabcells{ilin, CMATLAB} ;
      datastruct(iok).props.value    = tabcells{ilin, CVAL} ;
      datastruct(iok).props.unit     = tabcells{ilin, CUNIT} ;
      datastruct(iok).props.format   = tabcells{ilin, CFORMAT} ;
      datastruct(iok).props.position = iok ;
      datastruct(iok).props.opts = struct([]) ;

      genstruct.lists.fixedinput(kfixed) = iok ;

     case 'C'
      %============================================================
      % Calculated quantity fixed in set
      %============================================================
      iok = iok + 1 ;
      kcalc = kcalc + 1 ;

      datastruct(iok).type      = 'calc' ;
      
      thetext = tabcells{ilin, CTEXT} ;

      if isempty(thetext) || any(ismissing(thetext))
	thetext = ' ' ;
      end
      datastruct(iok).props.text     = thetext ;

      datastruct(iok).props.latex     = tabcells{ilin, CLATEX} ;
      datastruct(iok).props.matlab    = tabcells{ilin, CMATLAB} ;
      datastruct(iok).props.unit      = tabcells{ilin, CUNIT} ;
      datastruct(iok).props.format    = tabcells{ilin, CFORMAT} ;
      datastruct(iok).props.position  = iok ;
      datastruct(iok).props.opts = struct([]) ;

      genstruct.lists.calc(kcalc) = iok ;
      
     case {'Q', 'Q*'}
      %============================================================
      % Question
      %============================================================
      iok = iok + 1 ;
      kquestion = kquestion + 1 ;
      
      thetext = tabcells{ilin, CTEXT} ;

      datastruct(iok).type      = 'question' ;
      
      if isempty(thetext) || any(ismissing(thetext))
	thetext = ' ' ;
      end
      datastruct(iok).props.text     = thetext ;

      datastruct(iok).props.latex     = tabcells{ilin, CLATEX} ;
      datastruct(iok).props.matlab    = tabcells{ilin, CMATLAB} ;
      datastruct(iok).props.unit      = tabcells{ilin, CUNIT} ;
      datastruct(iok).props.format    = tabcells{ilin, CFORMAT} ;
      datastruct(iok).props.position  = iok ;
      datastruct(iok).props.opts = [] ;
      
      % Variant Q*
      if numel(code) == 2 && code(2) == '*'
	datastruct(iok).props.opts.DisplayLatexName = 0 ;
      end
      
      %----------------------------------------
      % Examine if point field is correct
      %----------------------------------------
      points = tabcells{ilin, CPOINTS} ;

      if any(ismissing(points)) || isempty(points)
	% Void points field, we set to 1 by default
	datastruct(iok).props.points = 1 ;
      else
	% Not void points field...
	if ~isnumeric(points)
	  % We test if not numeric
	  nerrors = nerrors  + 1 ;
	  errorstruct(nerrors).code = errorcodes.POINTS_NOT_NUMERIC ;
	  errorstruct(nerrors).line = ilin ;
	  errorstruct(nerrors).string = points ;
	  
	else
	  % OK, points field is indeed a number.
	  % We test if integer
	  if decim(points) == 0 && points > 0
	    % OK it's integer, assign points in datastruct
	    datastruct(iok).props.points = points ;
	  else
	    % It's not integer : error
	    nerrors = nerrors  + 1 ;
	    errorstruct(nerrors).code = errorcodes.POINTS_NOT_INTEGER ;
	    errorstruct(nerrors).line = ilin ;
	    errorstruct(nerrors).string = num2str(points) ;
	  end
	end 
      end
      
      genstruct.lists.question(kquestion) = iok ;

      
     otherwise
	nerrors = nerrors  + 1 ;
	errorstruct(nerrors).code = errorcodes.WRONG_CODE ;
	errorstruct(nerrors).line = ilin ;
	errorstruct(nerrors).string = code  ;
    end
    
  else 
    % If line is a comment
  end
  
  done = (ilin == nlines) ;

end

% We found no tolerance line
if ~TOL_WAS_FOUND
  nerrors = nerrors  + 1 ;
  errorstruct(nerrors).code = errorcodes.TOL_UNSPECIFIED ;
  errorstruct(nerrors).line = 0 ;
end

% We found no nset line
if ~NSET_WAS_FOUND
  nerrors = nerrors  + 1 ;
  errorstruct(nerrors).code = errorcodes.NSET_UNSPECIFIED ;
  errorstruct(nerrors).line = 0 ;
end

if ~MOODLECAT_WAS_FOUND
  genstruct.moodlecategory = [] ; 
end
