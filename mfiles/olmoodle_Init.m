% OLMOODLE_INIT:
%
% Opens the output LaTeX file from first copying data/tex/start.tex
% to the output file.
% The header for quiz section is also written, with the information
% for category (see moodle LaTeX class documentation).
%
%
% Usage: 
% fid = olmoodle_Init (OutputFile, TO_FILE_FLAG, QuestionCategory, StartFilename)
%
% On input :
%  OutputFile : 
%      fFull name of the output file. This is the same basename
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

function fid = olmoodle_Init (OutputFile, ...
			      TO_FILE_FLAG, ...
			      QuestionCategory, ...
			      StartFilename)

DEFAULT_FILESTARTNAME = 'start.tex' ;
DEFAULT_MOODLE_CATEGORY = 'OLMoodle' ;

if nargin < 4
  error('StartFilename should be provided in arg 4')
end

if nargin < 3 || isempty(QuestionCategory)
    QuestionCategory = DEFAULT_MOODLE_CATEGORY ;
end

if nargin < 2 || isempty(TO_FILE_FLAG)
  TO_FILE_FLAG = 0 ;
end

if TO_FILE_FLAG
  copyok = copyfile(StartFilename, OutputFile) ; % Copie de l'entete
  if ~copyok
    warning('Can''t find start.tex. Check installation') ;
    fid = -1 ;
    return
  end
  [fid, err] = fopen( OutputFile, 'a') ;
else
  type start.tex
  fid = 1 ;
end

fprintf(fid, '\\begin{quiz}{%s} \n\n', QuestionCategory) ;

