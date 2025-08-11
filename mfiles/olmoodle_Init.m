function fid = olmoodle_Init (OutputFile, ...
			      TO_FILE_FLAG, ...
			      QuestionCategory, ...
			      StartFilename)

DEFAULT_FILESTARTNAME = 'start.tex' ;

if nargin < 4
  error('StartFilename shoudl be provided in arg 4')
end

if nargin < 3 || isempty(QuestionCategory)
    QuestionCategory = 'OLMoodle' ;
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

