clear

% Set to 1 to generate a latex file. Otherwise, the file content
% will be displayed to screen (useful for debug)
TOFILE  = 1 ; 

% Get installation path and deduce various files and paths
pathstruct = olmoodle_GetPaths () ;

OutputPath = './' ;

% HomePath = getenv('HOME') ;

% ======================================================================
%
% Read all texts, answers, keyword etc of the code, including the code
% parts to be written in mycode.m. This system is meant for
% internationalization
%
% ======================================================================
textstruct = olmoodle_ReadTexts (pathstruct.TextsFilename) ;

% ======================================================================
%
% Definie error codes
%
% ======================================================================
errorcodes = olmoodle_DefineErrorCodes() ;
%

% ====================================================================== 
%
% Read Excel file
%
% ====================================================================== 

% Ask for Excel filename
xlsfilename = askfilename( {'.xlsx','.xls'}, 1, ...
			   textstruct.message.AskFileName{1}) ;

WriteTextBlocks(1, textstruct.message.ReadExcelFile) ;

%----------------------------------------------------------------------
% Let's open the funny Excel !
%----------------------------------------------------------------------
[excelstruct, lists, errorstruct] = ...
    olmoodle_ReadExcel (xlsfilename, errorcodes) ;

% ====================================================================== 
%
% Detect errors, then manage error display
%
% ====================================================================== 
% Detect errors in Excel files
[datastruct, errorstruct, genstruct] = ...
    olmoodle_CheckFields (excelstruct, errorstruct, errorcodes) ;

% Add lists to genstruct
genstruct.lists = lists ;

ierr = olmoodle_ManageErrors( errorstruct, errorcodes, textstruct) ;

% WE FOUND ERRORS. WE STOP HERE !
if ierr == -1
  fprintf( textstruct.error.Found{1} )  ;
  fprintf( '\n' )  ;
  return
end

% ====================================================================== 
%
% Output LaTeX file name
%
% ====================================================================== 
% Output tex file has the same name than input xlsfilename
OutputFilename = modsuf(xlsfilename, '.tex') ;
OutputFile = [OutputPath, '/', OutputFilename ] ;

% ====================================================================== 
%
% Create numeric sets
%
% ====================================================================== 
WriteTextBlocks(1, textstruct.message.CreateDataSets) ;

myins = olmoodle_CreateSets (genstruct, datastruct) ;

%WriteTextBlocks(1, 'OK') ;


% ====================================================================== 
%
% Create own code if required
%
% ====================================================================== @
WriteTextBlocks(1, textstruct.message.CreateUserCode) ;

mycodecreated = olmoodle_CreateMyCode( genstruct, datastruct, ...
				       textstruct) ;

% ====================================================================== 
%
% Execute own code
%
% ====================================================================== 
WriteTextBlocks(1, textstruct.message.ExecUserCode) ;

myouts = olmoodle_ExecMyCode (genstruct, datastruct, myins) ;

% ====================================================================== 
%
% Initialization, opening latex file
%
% ====================================================================== 
WriteTextBlocks(1, textstruct.message.InitLatexFile) ;

fid = olmoodle_Init (OutputFile, TOFILE, ...
		     genstruct.moodlecategory, ...
		     pathstruct.StartFilename) ;

WriteTextBlocks(1, textstruct.message.WriteLatexFile) ;

if fid < 0
  return ;
end

% ======================================================================
%
% MAIN LOOP.
%
% ======================================================================

fprintf(1, '%s : ', textstruct.message.Dataset{1}) ;
  

for iset = 1 : genstruct.nset

  fprintf(1, '%d ', iset) ;
  
  fprintf(fid, ' \\begin{cloze}{%s} \n', genstruct.header) ;

  for n = 1 : numel(datastruct)

    switch datastruct(n).type
      
     case 'text'
      %--------------------------------------------------
      % Pure text
      %--------------------------------------------------
      olmoodle_DisplayText (fid, datastruct(n).props.text) ;

     case 'fixedinput'
      %--------------------------------------------------
      % Input quantity fixed in set
      %--------------------------------------------------
      matlabname = datastruct(n).props.matlab ;

      olmoodle_DisplayInputData (fid,  struct(...
	  'sentence', datastruct(n).props.text, ...
	  'latex', datastruct(n).props.latex, ...
	  'value', myins.(matlabname), ...
	  'format', datastruct(n).props.format, ...
	  'unit', datastruct(n).props.unit ...
	  ) ) ;
      
      case 'tol'
      %----------------------------------------------------------
      % Tolerance (displayed similarly as input fixed quantities 
      % except that no latex name is printed)
      %----------------------------------------------------------
      olmoodle_DisplayInputData (fid,  struct(...
	  'sentence', datastruct(n).props.text, ...
	  'value', genstruct.tolpercent, ...
	  'format', datastruct(n).props.format, ...
	  'unit', datastruct(n).props.unit ...
	  ), [], struct(...
	      'displayequalsign', 0) ) ;

     case 'varinput'
      %--------------------------------------------------
      % Input quantity variable in set
      %--------------------------------------------------
      matlabname = datastruct(n).props.matlab ;
      
      olmoodle_DisplayInputData (fid, struct(...
	  'sentence', datastruct(n).props.text, ...
	  'latex', datastruct(n).props.latex, ...
	  'value', myins.(matlabname)(iset), ...
	  'format', datastruct(n).props.format, ...
	  'unit', datastruct(n).props.unit ...
	  ) ) ;
      
     case 'calcinput'
      %--------------------------------------------------
      % Calculated quantity fixed in set
      %--------------------------------------------------
      matlabname = datastruct(n).props.matlab ;
      
      olmoodle_DisplayInputData (fid, struct(...
	  'sentence', datastruct(n).props.text, ...
	  'latex', datastruct(n).props.latex, ...
	  'value', myouts.(matlabname).value(iset), ...
	  'format', datastruct(n).props.format, ...
	  'unit', datastruct(n).props.unit ... 
	  ) ) ;
      
      
     case 'question'
      %--------------------------------------------------
      % Question
      %--------------------------------------------------
      matlabname = datastruct(n).props.matlab ;

      olmoodle_DisplayAnswerField (fid,  struct(...
	  'sentence', datastruct(n).props.text, ...
	  'latex', datastruct(n).props.latex, ...
	  'value', myouts.(matlabname).value(iset), ...
	  'unit', datastruct(n).props.unit, ...
	  'min', myouts.(matlabname).min, ...
	  'max', myouts.(matlabname).max, ...
	  'format', datastruct(n).props.format, ...
	  'points', datastruct(n).props.points, ...
	  'tol', genstruct.tol ...
	  ),  [], datastruct(n).props.opts  ) ;
      
     otherwise
    end 
  end

  fprintf(fid, '\\end{cloze} \n') ;
  fprintf(fid, '\n') ;
  fprintf(fid, '\n') ;
    
end

% ====================================================================== 
%
% END. Closing latex file
%
% ====================================================================== 

fprintf(1, '\n')

fprintf(fid, '\\end{quiz}\n') ;
fprintf(fid, '\\end{document}\n') ;

if TOFILE
  fclose (fid) ;
end

% ====================================================================== 
%
% Final message to user
%
% ====================================================================== 
WriteTextBlocks(1, textstruct.message.SepLine{1} ) ;
WriteTextBlocks(1, textstruct.message.YouCanCompile ) ;
fprintf(1, 'xelatex %s \n', OutputFilename)

WriteTextBlocks(1, textstruct.message.LaunchMeAgain ) ;
WriteTextBlocks(1, textstruct.message.SepLine{1} ) ;

