% -*- coding: utf-8 -*-
%
% OLMOODLE_CHECKFIELDS:
%
% Check if fields found in Excel file are correct, one by one, and
% return error info.

function [datastruct, errorstruct, genstruct] = ...
    olmoodle_CheckFields (excelstruct, errorstruct, errorcodes)


datastruct = excelstruct ;

% Initializing number of errors
nerrors = numel(errorstruct) ;

% Foreach line stored from Excel file
for ifield = 1:numel(excelstruct)


  switch excelstruct(ifield).type
    
   case 'moodlecat'
    %======================================================================
    % Moodle category
    %======================================================================
    tmp  = excelstruct(ifield).props.value ;    
    typecat = olmoodle_CheckOneField( tmp) ;

    if typecat.isvoid
      % If empty moodle category, we leave blank
      % The default category will be used in Moodle in this case
      genstruct.moodlecategory = ' ' ; 
    else
      % Moodle category is OK.
      % One should check against underscores in the path in the
      % future, that make LaTeX hang...
      genstruct.moodlecategory = tmp ;     
    end

    
   case 'header'
    %======================================================================
    % Header
    %======================================================================
    tmp  = excelstruct(ifield).props.value ;    
    typecat = olmoodle_CheckOneField( tmp) ;

    if typecat.isvoid
      % If empty header, we set to 'Numerical question'
      genstruct.header = 'Numerical question' ; 
    else
      % Header is not void.
      genstruct.header = tmp ;     
    end

    % Extract pdfmode.
    genstruct.pdfmode = excelstruct(ifield).props.mode ;

    
   case 'numberofsets'
    %======================================================================
    % Number of sets
    %======================================================================
    tmp  = excelstruct(ifield).props.value ;    
    typecat = olmoodle_CheckOneField( tmp) ;

    if  typecat.isvoid
      % Nset value is void
      nerrors = nerrors  + 1 ;
      errorstruct(nerrors).code = errorcodes.NSET_IS_VOID ;
      errorstruct(nerrors).line = excelstruct(ifield).lineinexcel ;
      
    elseif ~typecat.isinteger
      % Nset value is not integer
      nerrors = nerrors  + 1 ;
      errorstruct(nerrors).code = errorcodes.NSET_BADLY_SPECIFIED ;
      errorstruct(nerrors).line = excelstruct(ifield).lineinexcel ;
      errorstruct(nerrors).string = tmp  ;
    else
      % Nset value is OK
      genstruct.nset = tmp ;     
    end
    
    
   case 'tol'
    %======================================================================
    % Tolerance
    %======================================================================
    
    %---------------------------------------
    % Examine tolerance value
    %---------------------------------------
    tolvalue  = excelstruct(ifield).props.value ;    
    typecat = olmoodle_CheckOneField( tolvalue) ;
    
    if typecat.isvoid
      %----------------------------------------
      % Tolerance value is void
      %----------------------------------------
      nerrors = nerrors  + 1 ;
      errorstruct(nerrors).code = errorcodes.TOL_IS_VOID ;
      errorstruct(nerrors).line = excelstruct(ifield).lineinexcel ;
      
    elseif typecat.isnotnumeric
      %----------------------------------------
      % Tolerance value is not numeric
      %----------------------------------------
      nerrors = nerrors  + 1 ;
      errorstruct(nerrors).code = errorcodes.TOL_BADLY_SPECIFIED ;
      errorstruct(nerrors).line = excelstruct(ifield).lineinexcel ;
      errorstruct(nerrors).string = tolvalue ;
    else
      %----------------------------------------
      % Tolerance value is OK
      % Examine if unit of tolerance is correct
      %----------------------------------------
      tolunitstr = excelstruct(ifield).props.unit ;
      typecat = olmoodle_CheckOneField( tolunitstr) ;
      
      if typecat.isvoid
	% Tolerance unit field is void
	% Tolerance should be understood as is
	genstruct.tol = excelstruct(ifield).props.value ;
	genstruct.tolpercent = genstruct.tol * 100 ;

      elseif typecat.isnotnumeric
	% Tolerance unit field is not void and made of characters ...
	
	if StringInsideBlanks(lower(tolunitstr), 'percent')
	  % Check if contains 'percent', possibly enclosed within
	  % blank-like characters
	  genstruct.tolpercent = excelstruct(ifield).props.value ;
	  genstruct.tol = genstruct.tolpercent / 100 ;
	  
	else
	  % Otherwise error
	  nerrors = nerrors  + 1 ;
	  errorstruct(nerrors).code = errorcodes.TOL_BAD_UNIT ;
	  errorstruct(nerrors).line = excelstruct(ifield).lineinexcel ;
	  errorstruct(nerrors).string = excelstruct(ifield).props.unit ;
	end
      end
    end
    

   case 'text'
    %======================================================================
    % Text
    %======================================================================

    % Nothing special here. Validity of text is examined below
    
    
   case 'varinput'
    %======================================================================
    % Variable input
    %======================================================================

    %-----------------------------------------------------
    % Detect values errors in min and max. They should be
    % numerical
    %-----------------------------------------------------
    min = excelstruct(ifield).props.min ;
    typecat = olmoodle_CheckOneField( min) ;

    if typecat.isnotnumeric
      nerrors = nerrors  + 1 ;
      errorstruct(nerrors).code = errorcodes.VALUE_NOT_NUMERIC ;
      errorstruct(nerrors).line = excelstruct(ifield).lineinexcel ;
      errorstruct(nerrors).string = min ;
    end

    max = excelstruct(ifield).props.max ;
    typecat = olmoodle_CheckOneField( max) ;

    if typecat.isnotnumeric
      nerrors = nerrors  + 1 ;
      errorstruct(nerrors).code = errorcodes.VALUE_NOT_NUMERIC ;
      errorstruct(nerrors).line = excelstruct(ifield).lineinexcel ;
      errorstruct(nerrors).string = max ;
    end

    %-----------------------------------------------------
    % Detect precision errors. Precision should be integer
    % Void is accepted
    %-----------------------------------------------------
    precision = excelstruct(ifield).props.precision ;
    typecat = olmoodle_CheckOneField( precision) ;

      if typecat.isvoid
	% Void precision field
	nerrors = nerrors  + 1 ;
	errorstruct(nerrors).code = errorcodes.PRECISION_UNSPECIFIED ;
	errorstruct(nerrors).line = excelstruct(ifield).lineinexcel ;
	
      else % Not void precision field...

	% If not numeric, error
	if typecat.isnotnumeric
	  nerrors = nerrors  + 1 ;
	  errorstruct(nerrors).code = errorcodes.PRECISION_NOT_NUMERIC ;
	  errorstruct(nerrors).line = excelstruct(ifield).lineinexcel ;
	  errorstruct(nerrors).string = precision ;
	  
	else % OK, precision field is indeed a number.
	     % We test if integer
	     if  ~typecat.isinteger
	       % It's not integer : error
	       nerrors = nerrors  + 1 ;
	       errorstruct(nerrors).code = errorcodes.PRECISION_NOT_INTEGER ;
	       errorstruct(nerrors).line = excelstruct(ifield).lineinexcel ;
	       errorstruct(nerrors).string = num2str(precision) ;
	     end
	end 
      end

      
   case 'fixedinput'
    %======================================================================
    % Fixed input
    %======================================================================

    %-----------------------------------------------------
    % Detect error in value. It should be numerical
    %-----------------------------------------------------
    value = excelstruct(ifield).props.value ;
    typecat = olmoodle_CheckOneField( value) ;

    if typecat.isnotnumeric
      nerrors = nerrors  + 1 ;
      errorstruct(nerrors).code = errorcodes.VALUE_NOT_NUMERIC ;
      errorstruct(nerrors).line = excelstruct(ifield).lineinexcel ;
      errorstruct(nerrors).string = value ;
    end

    
   case 'calcinput'
    %======================================================================
    % Calculated input
    %======================================================================
    

   case 'question'
    %======================================================================
    % Question
    %======================================================================
    
    %----------------------------------------
    % Examine if point field is correct
    %----------------------------------------
    points = excelstruct(ifield).props.points ;
    typecat = olmoodle_CheckOneField( points ) ;

    if typecat.isvoid
	% Void points field, we set to 1 by default
	datastruct(ifield).props.points = 1 ;
    else
      % Not void points field...
      if typecat.isnotnumeric
	  % We test if not numeric
	  nerrors = nerrors  + 1 ;
	  errorstruct(nerrors).code = errorcodes.POINTS_NOT_NUMERIC ;
	  errorstruct(nerrors).line = excelstruct(ifield).lineinexcel ;
	  errorstruct(nerrors).string = points ;
	  
	else
	  % OK, points field is indeed a number.
	  % We test if integer and positive
	  if typecat.isinteger && points > 0
	    % OK it's integer
	  else
	    % It's not integer : error
	    nerrors = nerrors  + 1 ;
	    errorstruct(nerrors).code = errorcodes.POINTS_NOT_INTEGER ;
	    errorstruct(nerrors).line = excelstruct(ifield).lineinexcel ;
	    errorstruct(nerrors).string = num2str(points) ;
	  end
      end 
    end

   otherwise
    error('Bad code. This should not happen\n') ; 
  end

  
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Check all text fields on one shot
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Foreach line stored from Excel file
for ifield = 1:numel(excelstruct)

  switch excelstruct(ifield).type

   case {'text', 'varinput', 'fixedinput', 'calcinput', 'question', 'tol'}
    
    % Check if not numeric (this is not normal in my opinion)
    textstr = excelstruct(ifield).props.text ;
    typecat = olmoodle_CheckOneField( textstr) ;
    
    if typecat.isvoid
      % Text is void, we replace by a blank space
      datastruct(ifield).props.text = ' ' ;
      
    elseif typecat.isnumeric
      % Text is numeric
      nerrors = nerrors  + 1 ;
      errorstruct(nerrors).code = errorcodes.TEXT_IS_NUMERIC ;
      errorstruct(nerrors).line = excelstruct(ifield).lineinexcel ;
    end
  end
end



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Check all unit fields on one shot and take this occasion to
% format all units
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Foreach line stored from Excel file
for ifield = 1:numel(excelstruct)

  switch excelstruct(ifield).type
    
   case {'varinput', 'fixedinput', 'calcinput', 'question', 'tol'}
    
    unitstr = excelstruct(ifield).props.unit ;

    % Apply unit decoding routine
    [unitlatexstring, uniterr] = olmoodle_FormatUnit (unitstr) ;
    
    % There is an error
    switch uniterr.code 
     
     case -1
      % Separator forgotten between some unit fields
      nerrors = nerrors + 1 ;
      errorstruct(nerrors).code = errorcodes.UNIT_FORGOT_SEPARATOR ;
      errorstruct(nerrors).line = excelstruct(ifield).lineinexcel ;
      errorstruct(nerrors).unitfield = unitfield.numfield ;
      
      case -2
      % No letter in some unit field
      nerrors = nerrors + 1 ;
      errorstruct(nerrors).code = errorcodes.UNIT_NO_LETTER ;
      errorstruct(nerrors).line = excelstruct(ifield).lineinexcel ;
      errorstruct(nerrors).unitfield = unitfield.numfield ;
     
     case -3
      % Bad exponent in some unit field
      nerrors = nerrors + 1 ;
      errorstruct(nerrors).code = errorcodes.UNIT_BAD_EXPONENT ;
      errorstruct(nerrors).line = excelstruct(ifield).lineinexcel ;
      errorstruct(nerrors).unitfield = unitfield.numfield ;
     
     case 0
      % Unit field is correct, we store it into datastruct
      datastruct(ifield).props.unit = unitlatexstring ;
      
      otherwise
    end
  end
end
