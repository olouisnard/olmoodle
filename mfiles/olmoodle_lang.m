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
% Copy files 
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

% Display fonal message so that the user can see that it worked

% Read texts
textstruct = olmoodle_ReadTexts (pathstruct.TextsFilename) ;

fprintf(1, '%s\n', textstruct.message.Lang{1}) ;

