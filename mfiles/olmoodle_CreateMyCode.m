

function CREATE_MYCODE = olmoodle_CreateMyCode (genstruct, datastruct, textstruct)


replacements(1).from = '%' ;
replacements(1).to = '%%' ;

% ======================================================================
% If mycode.m does not exist, create default, otherwise asks the user
% if he wants to re-create
% ======================================================================
if ~exist('mycode.m', 'file')  
  CREATE_MYCODE = 1 ;

else
  done = 0 ;

  CREATE_MYCODE = askyesno( textstruct.question.CreateMyCode{1}, ...
	    textstruct.answer.yes, ...
	    textstruct.answer.no, ...
	    0) ;
end

% Create the defaut code
if CREATE_MYCODE
  fidmycode = fopen('mycode.m', 'w', 'n', 'UTF-8') ;
  fprintf(fidmycode, '%% -*- coding: utf-8 -*-\n\n') ;


  %======================================================================  
  %
  % Writing comments in matlab file
  %
  %======================================================================  
  %----------------------------------------------------------------------
  % General header comment
  %----------------------------------------------------------------------
  WriteTextBlocks(fidmycode, textstruct.mycode.info_commentoutputs, replacements) ;
  
  %----------------------------------------------------------------------
  % General introductory comment on inputs
  %----------------------------------------------------------------------
  WriteTextBlocks( fidmycode,  textstruct.mycode.info_inputs, replacements) ;
  
%----------------------------------------------------------------------
% Matlab assignments lines for fixed data
%----------------------------------------------------------------------
  WriteTextBlocks(fidmycode, textstruct.mycode.info_fixedinputs, replacements) ;
  
  for kfixed = 1 : numel(genstruct.lists.fixedinput)
    indfixed = genstruct.lists.fixedinput(kfixed) ;
    fprintf( fidmycode, '%% %s\t:\t%s\n', ...
	     datastruct(indfixed).props.matlab, datastruct(indfixed).props.text) ;
  end

  fprintf( fidmycode, '\n') ;
  
%----------------------------------------------------------------------
% Matlab assignments lines for varying data
%----------------------------------------------------------------------
  WriteTextBlocks(fidmycode, textstruct.mycode.info_varinputs, replacements) ;

  for kvar = 1 : numel(genstruct.lists.varinput)
    indvar = genstruct.lists.varinput(kvar) ;
    fprintf( fidmycode, '%% %s\t:\t%s\n', ...
	     datastruct(indvar).props.matlab, datastruct(indvar).props.text) ;
  end

  
  fprintf( fidmycode, '\n') ;

  %----------------------------------------------------------------------
  % Matlab assignments lines for calculated inputs
  %----------------------------------------------------------------------
  WriteTextBlocks(fidmycode, textstruct.mycode.info_calcinputs, replacements) ;
  
  for kcalc = 1 : numel(genstruct.lists.calc)
    indcalc = genstruct.lists.calc(kcalc) ;
    
    fprintf( fidmycode, '%%----------------------------------------------------------------------\n') ;
    fprintf( fidmycode, '%% %s\n', datastruct(indcalc).props.text) ;
    fprintf( fidmycode, '%%----------------------------------------------------------------------\n') ;
    
    fprintf( fidmycode, '%s = zzz ; \n\n', datastruct(indcalc).props.matlab ) ;      
  end
  
  fprintf( fidmycode, '\n') ;

  %----------------------------------------------------------------------
  % Matlab assignment lines for answers to questions
  %----------------------------------------------------------------------
  WriteTextBlocks(fidmycode, textstruct.mycode.info_outputs, replacements) ;

  for kquestion = 1 : numel(genstruct.lists.question)
    indquestion = genstruct.lists.question(kquestion) ;
    
    fprintf( fidmycode, '%%----------------------------------------------------------------------\n') ;
    fprintf( fidmycode, '%% %s\n', datastruct(indquestion).props.text) ;
    fprintf( fidmycode, '%%----------------------------------------------------------------------\n') ;
    
    fprintf( fidmycode, '%s = zzz ; \n\n', datastruct(indquestion).props.matlab ) ;      
  end

  fclose(fidmycode) ;

  %----------------------------------------------------------------------
  % Displays message stating that file has been created.
  %----------------------------------------------------------------------
  WriteTextBlocks (1, textstruct.message.SepLine) ;
  WriteTextBlocks (1, textstruct.message.UserCodeCreated) ;
  WriteTextBlocks (1, textstruct.message.SepLine) ;
  
  open mycode.m
  
  input( textstruct.message.PressEnter{1}, 's');

end
