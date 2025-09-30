% -*- coding: utf-8 -*-
%
% OLMOODLE_READEXCEL :
%
% Reads input Excel file and decode. Rough datas ar are stored in
% excelstruct. 
%
% Most of the checks will be delayed in olmoodle_checkfields.

function [excelstruct, lists, errorstruct] = ...
    olmoodle_ReadExcel (xlsfilename, errorcodes)


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

lists.varinput = [] ;
lists.fixedinput = [] ;
lists.calc = [] ;
lists.question = [] ;

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
    
    switch code(1)
      
     case 'M'
      %============================================================
      % Moodle category to store questions
      %============================================================
      iok = iok + 1 ;

      excelstruct(iok).type        = 'moodlecat' ;
      excelstruct(iok).lineinexcel = ilin ;
      excelstruct(iok).props.value = tabcells{ilin, CMOODLECAT} ; 
      
      MOODLECAT_WAS_FOUND = 1 ;
     
     case {'H', 'H*'}
      %============================================================
      % Header (the title of generated question)
      %============================================================
      iok = iok + 1 ;
      excelstruct(iok).type        = 'header' ;
      excelstruct(iok).lineinexcel = ilin ;
      excelstruct(iok).props.value = tabcells{ilin, CHEADER} ; 
      excelstruct(iok).props.mode = 1 ; % Default: output pdf file
                                        % is corrected 
     
      % Variant H*: 
      % output pdf file % is uncorrected 
      if numel(code) == 2 && code(2) == '*'
	excelstruct(iok).props.mode = 0 ;
      end
      
     case 'N'
      %============================================================
      % Number of sets
      %============================================================
      iok = iok + 1 ;
      excelstruct(iok).type        = 'numberofsets' ;
      excelstruct(iok).lineinexcel = ilin ;
      excelstruct(iok).props.value = tabcells{ilin, CNUMBEROFSET} ; 

      NSET_WAS_FOUND = 1 ;
      
     case 'Z'
      %============================================================
      % Tolerance
      %============================================================
      iok = iok + 1 ;
      excelstruct(iok).type = 'tol' ;
      excelstruct(iok).lineinexcel = ilin ;

      tolstr = tabcells{ilin, CTOLERANCE} ;    
      TOL_WAS_FOUND = 1 ;
      
      excelstruct(iok).props.text     = tabcells{ilin, CTEXT} ;
      excelstruct(iok).props.value    = tabcells{ilin, CVAL} ;
      excelstruct(iok).props.format   = tabcells{ilin, CFORMAT} ;
      excelstruct(iok).props.unit     = tabcells{ilin, CUNIT} ;
     
     case 'T'
      %============================================================
      % Pure text
      %============================================================
      iok = iok + 1 ;
      ktext = ktext + 1;

      excelstruct(iok).type       = 'text' ;
      excelstruct(iok).lineinexcel = ilin ;

      excelstruct(iok).props.text     = tabcells{ilin, CTEXT} ;

      lists.text(ktext) = iok ;
      
      % Variant T..
      excelstruct(iok).props.opts = DecodeVariant(code) ;

     
     case 'V'
      %============================================================
      % Input quantity variable in set
      %============================================================
      iok = iok + 1 ;
      kvar = kvar + 1;
 
      excelstruct(iok).type      = 'varinput' ;
      excelstruct(iok).lineinexcel = ilin ;

      excelstruct(iok).props.text      = tabcells{ilin, CTEXT} ;
      excelstruct(iok).props.latex     = tabcells{ilin, CLATEX} ;
      excelstruct(iok).props.matlab    = tabcells{ilin, CMATLAB} ;
      excelstruct(iok).props.min       = tabcells{ilin, CMIN} ;
      excelstruct(iok).props.max       = tabcells{ilin, CMAX} ;
      excelstruct(iok).props.precision = tabcells{ilin, CPREC} ;
      excelstruct(iok).props.unit      = tabcells{ilin, CUNIT} ;
      excelstruct(iok).props.format    = tabcells{ilin, CFORMAT} ;

      lists.varinput(kvar) = iok ;

       % Variants V.. and V*
       excelstruct(iok).props.opts = DecodeVariant(code) ;
      
     case 'F'
      %============================================================
      % Input quantity fixed in set
      %============================================================
      iok = iok + 1 ;
      kfixed = kfixed + 1;

      excelstruct(iok).type     = 'fixedinput' ;
      excelstruct(iok).lineinexcel = ilin ;
      
      excelstruct(iok).props.text     = tabcells{ilin, CTEXT} ;
      excelstruct(iok).props.latex    = tabcells{ilin, CLATEX} ;
      excelstruct(iok).props.matlab   = tabcells{ilin, CMATLAB} ;
      excelstruct(iok).props.value    = tabcells{ilin, CVAL} ;
      excelstruct(iok).props.unit     = tabcells{ilin, CUNIT} ;
      excelstruct(iok).props.format   = tabcells{ilin, CFORMAT} ;

      lists.fixedinput(kfixed) = iok ;

      % Variants F.. and F*
      excelstruct(iok).props.opts = DecodeVariant(code) ;

     
     case 'C'
      %============================================================
      % Calculated quantity fixed in set
      %============================================================
      iok = iok + 1 ;
      kcalc = kcalc + 1 ;

      excelstruct(iok).type      = 'calcinput' ;
      excelstruct(iok).lineinexcel = ilin ;
      
      excelstruct(iok).props.text      = tabcells{ilin, CTEXT} ;
      excelstruct(iok).props.latex     = tabcells{ilin, CLATEX} ;
      excelstruct(iok).props.matlab    = tabcells{ilin, CMATLAB} ;
      excelstruct(iok).props.unit      = tabcells{ilin, CUNIT} ;
      excelstruct(iok).props.format    = tabcells{ilin, CFORMAT} ;

      lists.calc(kcalc) = iok ;
     
      % Variants C.. and C*
      excelstruct(iok).props.opts = DecodeVariant(code) ;

     
     case 'Q'
      %============================================================
      % Question
      %============================================================
      iok = iok + 1 ;
      kquestion = kquestion + 1 ;
      
      excelstruct(iok).type      = 'question' ;
      excelstruct(iok).lineinexcel = ilin ;
      
      excelstruct(iok).props.text      = tabcells{ilin, CTEXT} ;
      excelstruct(iok).props.latex     = tabcells{ilin, CLATEX} ;
      excelstruct(iok).props.matlab    = tabcells{ilin, CMATLAB} ;
      excelstruct(iok).props.unit      = tabcells{ilin, CUNIT} ;
      excelstruct(iok).props.format    = tabcells{ilin, CFORMAT} ;
      excelstruct(iok).props.points    = tabcells{ilin, CPOINTS} ;

      % Variant Q*
      excelstruct(iok).props.opts = DecodeVariant(code) ;
      
      lists.question(kquestion) = iok ;
      
     otherwise
      %============================================================
      % Any non-official code
      %============================================================

	nerrors = nerrors  + 1 ;
	
	errorstruct(nerrors).code = errorcodes.WRONG_CODE ;
	errorstruct(nerrors).line = ilin ;
	errorstruct(nerrors).string = code  ;
    end
    
  else 
    % Line is a comment
  end
  
  done = (ilin == nlines) ; % Condition to end the loop

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
  nerrors = nerrors  + 1 ;
  errorstruct(nerrors).code = errorcodes.MOODLECAT_UNSPECIFIED ;
  errorstruct(nerrors).line = 0 ;
end


function opt = DecodeVariant(code)

DEFAULT_OPTS = struct('BreakLine', 1, ...
		      'DisplayLatexName', 1, ...
		      'DisplayEqualSign', 1 ) ;

opt = DEFAULT_OPTS ;

variant = code(2:end) ;

if ~isempty(variant)
  if contains (variant, '..')
    opt.BreakLine = 0;
  end
  
  if contains (variant, '*')
    opt.DisplayLatexName = 0;
  end
end


