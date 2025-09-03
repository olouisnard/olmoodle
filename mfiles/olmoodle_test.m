clear 

% Get installation path and deduce various files and paths
pathstruct = olmoodle_GetPaths () ;

% Read texts
textstruct = olmoodle_ReadTexts (pathstruct.TextsFilename) ;

fprintf(1, '%s\n', textstruct.message. OLmoodleIsHere{1}) ;

