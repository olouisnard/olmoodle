% -*- coding: utf-8 -*-
%
% OLMOODLE_INIT:
%
% Opens the output LaTeX file from first copying data/tex/start.tex
% to the output file.
% The header for quiz section is also written, with the information
% for category (see moodle LaTeX class documentation).
%
%
% Usage: 
% function fid = olmoodle_Init (OutputFile, ...
% 			      TO_FILE_FLAG, ...
% 			      QuestionCategory, ...
% 			      StartFilename)
%
% On input :
%  OutputFile : 
%      Full name of the output file. This is the same basename
%      as the Excel source file, with extension .tex.
%
%  TO_FILE_FLAG (optional): 
%      If set to 1, this is the normal behaviour. 
%      If set to 0 or omitted, the LaTeX content is output to screen
%                     instead of file. This is just a feature for
%                     debugging and should not be used.
%
% QuestionCategory: 
%        The path for the Moodle category where to create the
%        questions. This should be set in the Excel file. 
%        If omitted or void, the default category is OLMoodle
%
% StartFilename: the name of the LaTeX template start file.
%
% On ouput :
%  fid : 
%      The file handler of the output LaTeX file


function fid = olmoodle_Init (OutputFile, ...
			      TO_FILE_FLAG, ...
			      QuestionCategory, ...
			      StartFilename, ...
			      Mode)

DEFAULT_FILESTARTNAME = 'start.tex' ; % Base LaTeX file
DEFAULT_MOODLE_CATEGORY = 'OLMoodle' ; % Default moodle category

if nargin < 5
  Mode = 1 ; % By default, output pdf file with corrections
end

if nargin < 4
  error('StartFilename should be provided in arg 4')
end

if nargin < 3 || isempty(QuestionCategory)
    QuestionCategory = DEFAULT_MOODLE_CATEGORY ;
end

if nargin < 2 || isempty(TO_FILE_FLAG)
  TO_FILE_FLAG = 0 ;
end

%----------------------------------------------------------------------
% Copy start.tex file to current LaTeX file. 
%----------------------------------------------------------------------
if TO_FILE_FLAG
  % Normal behaviour, write LaTeX file
  copyok = copyfile(StartFilename, OutputFile) ; % Copie de l'entete
  if ~copyok
    warning('Can''t find start.tex. Check installation') ;
    fid = -1 ;
    return
  end
  [fid, err] = fopen( OutputFile, 'a') ;
else
  % Debug, write to screen instead of LaTeX file 
  type start.tex
  fid = 1 ;
end

if Mode == 1
  fprintf(fid, '\\usepackage{moodle} \n') ;
else
  fprintf(fid, '\\usepackage[handout]{moodle} \n') ;
end

fprintf(fid, '\\begin{document} \n') ;

fprintf(fid, '\\begin{quiz}{%s} \n\n', QuestionCategory) ;

