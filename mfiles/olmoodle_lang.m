% -*- coding: utf-8 -*-
%
clear

% The '/' chracter depends on system.
slashcar = filesep ;

% Get installation path
pathstruct = olmoodle_GetPaths () ;

% Determine all available languages
langdirs = olmoodle_GetLanguages (pathstruct) ;

% Number of langs
nlangs = numel(langdirs) ;

%----------------------------------------
% Build message to display
%----------------------------------------
% Initiate string to display

langstr = 'Select language: [' ;

for n = 1 : nlangs-1
  % Add current available language
  currentlangstr = sprintf('%s,', langdirs{n} ) ;
  langstr = append(langstr, currentlangstr  ) ;
end

% Add last available language
currentlangstr = sprintf('%s] ', langdirs{nlangs} ) ;
langstr = append(langstr, currentlangstr  ) ;


%----------------------------------------
% Ask user and check
%----------------------------------------
done = 0 ;

while ~done
  % Ask user to choose one
  selectedlang = input(langstr, 's') ;
  
  % Check if OK
  switch selectedlang
   case langdirs
    % If found, out of the loop
    done = 1 ;
   otherwise
    % Not found, ask again
    done = 0 ;
  end
end

%----------------------------------------
% Copy file olmoodle_texts.txt 
%----------------------------------------
% Source file
SourceFile = append(pathstruct.DataPath, ...
		    slashcar, ...
		    'txt', ...
		    slashcar, ...
		    selectedlang, ...
		    slashcar, ...
		    'olmoodle_texts.txt') ;

% Destination file
DestFile = append(pathstruct.DataPath, ...
		    slashcar, ...
		    'txt', ...
		    slashcar, ...
		    'olmoodle_texts.txt') ;

% Let's copy !
copyok = copyfile(SourceFile, DestFile) ; 

%----------------------------------------
% Copy file start.tex file
%----------------------------------------
% Source file
SourceFile = append(pathstruct.DataPath, ...
		    slashcar, ...
		    'tex', ...
		    slashcar, ...
		    selectedlang, ...
		    slashcar, ...
		    'start.tex') ;

% Destination file
DestFile = append(pathstruct.DataPath, ...
		    slashcar, ...
		    'tex', ...
		    slashcar, ...
		    'start.tex') ;

% Let's copy !
copyok = copyfile(SourceFile, DestFile) ; 

%======================================================================
% Display final message so that the user can see that it worked
%======================================================================

% Read texts (just for that !)
textstruct = olmoodle_ReadTexts (pathstruct.TextsFilename) ;

% Print message
fprintf(1, '%s\n', textstruct.message.Lang{1}) ;

