

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
  WriteTextBlocks( fidmycode,  textstruct.mycode.info_inputs, replacements) ;
  
  %======================================================================  
  %
  % Matlab assignments lines for fixed data
  %
  %======================================================================  
  WriteTextBlocks(fidmycode, textstruct.mycode.info_fixedinputs, replacements) ;
  
  for k = 1 : numel(genstruct.lists.fixedinput)
    n = genstruct.lists.fixedinput(k) ;
    fprintf( fidmycode, '%% %s\t:\t%s\n', ...
	     datastruct(n).props.matlab, datastruct(n).props.text) ;
  end

  fprintf( fidmycode, '\n') ;
  
%======================================================================  
%
% Matlab assignments lines for varying data
%
%======================================================================  
  WriteTextBlocks(fidmycode, textstruct.mycode.info_varinputs, replacements) ;

  for k = 1 : numel(genstruct.lists.varinput)
    n = genstruct.lists.varinput(k) ;
    fprintf( fidmycode, '%% %s\t:\t%s\n', ...
	     datastruct(n).props.matlab, datastruct(n).props.text) ;
  end

  
  fprintf( fidmycode, '\n\n\n') ;

  WriteTextBlocks(fidmycode, textstruct.mycode.info_outputs, replacements) ;

  
%======================================================================  
%
% Matlab assignments lines for calculated inputs
%
%======================================================================  
  for k = 1 : numel(genstruct.lists.calc)
    n = genstruct.lists.calc(k) ;

    fprintf( fidmycode, '%%----------------------------------------------------------------------\n') ;
    fprintf( fidmycode, '%% %s\n', datastruct(n).props.text) ;
    fprintf( fidmycode, '%%----------------------------------------------------------------------\n') ;
    
    fprintf( fidmycode, '%s = zzz ; \n\n', datastruct(n).props.matlab ) ;      
  end


%======================================================================  
%
  % Matlab assignment lines for answers to questions
%
%======================================================================  
  for k = 1 : numel(genstruct.lists.question)
    n = genstruct.lists.question(k) ;
    
    fprintf( fidmycode, '%%----------------------------------------------------------------------\n') ;
    fprintf( fidmycode, '%% %s\n', datastruct(n).props.text) ;
    fprintf( fidmycode, '%%----------------------------------------------------------------------\n') ;
    
    fprintf( fidmycode, '%s = zzz ; \n\n', datastruct(n).props.matlab ) ;      
  end

  fclose(fidmycode) ;

  % Displays message stating that file has been created.
  WriteTextBlocks (1, textstruct.message.SepLine) ;
  WriteTextBlocks (1, textstruct.message.UserCodeCreated) ;
  WriteTextBlocks (1, textstruct.message.SepLine) ;
  
  open mycode.m
  
  input( textstruct.message.PressEnter{1}, 's');

end
