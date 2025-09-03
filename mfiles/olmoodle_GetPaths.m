% OLMOODLE_GETPATHS:
%
% Determine where is the root installation path, and from there,
% the location of data path

function out = olmoodle_GetPaths ()

% The '/' chracter depends on system.
slashcar = filesep ;

% Get installation path 
% This yields for example /home/macron/matlab/OLMOODLE/mfiles
% Where is olmoodle_main ?
execfolder = which('olmoodle_main') ;

% We remove trailing "mfiles"
[~, ~, paths] = PathCut(execfolder) ;

InstallPath = append(paths{1}, slashcar) ;

% Path for data
out.DataPath = append(InstallPath, 'data') ;

% Path for Latex files
out.StartFilename = append(InstallPath, 'data', slashcar, 'tex', slashcar, 'start.tex') ;

% Path for text files
out.TextsFilename = append(InstallPath, 'data', slashcar, 'txt', slashcar, 'olmoodle_texts.txt') ;

out.InstallPath = InstallPath ;
