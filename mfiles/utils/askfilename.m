% ASKFILENAME : demande un nom de fichier à l'utilisateur et le
% renvoie. 
%
% extension : masque pour lister les fichiers existants.
% askname   : si 0, on ne demande rien, et on revient
% message   : Pour changer le message d'invite par defaut
% 
%
% Usage :     filename = askfilename (extension, askname, message)

function filename = askfilename (extension, askname, message)

DEFAULT_MESSAGE = 'File to load: ' ;

% --------------------------------------------------------------- 
%  Si pas d'argument message, message par défaut
% ---------------------------------------------------------------
if nargin < 3 || isempty(message)
  message = DEFAULT_MESSAGE ;
end

% --------------------------------------------------------------- 
%  Si pas d'argument askname, mode bavard par défaut
% ---------------------------------------------------------------
if nargin < 2 || isempty(askname)
  askname = 1 ;
end

% ---------------------------------------------------------------
% Si le parametre askname vaut 0, on ne demande pas le nom du
% fichier (en général c'est qu'il est déjà défini à l'extérieur,
% dans le cadre d'une étude paramétrique, ou on récupère les
% résultats de plusieurs fichier)
% ---------------------------------------------------------------
if ~askname
  return
end

% ---------------------------------------------------------------
% Gestion des extensions
% ---------------------------------------------------------------
if isstring(extension) || ischar(extension)
  COMPATIBILITY_MODE = 1 ;
  next = 1 ;
  
elseif iscellstr(extension)
  COMPATIBILITY_MODE = 0 ;
  next = numel(extension) ;  

else
  fprintf(1, 'ERROR : Bad type for argument extension. I stop \n') ;
  return
end

% -----------------------------------------------
% Recherche du dernier fichier créé dans last.tmp
% resultat dans la chaine lastprob
% -----------------------------------------------
EXIST_LAST = 0 ;
fid = fopen('last.tmp', 'r') ;

if fid >= 0
  % Le fichier last.tmp, existe et est ouvrable
  lastprob = fscanf (fid, '%s', 1);
  fclose(fid);
  
  for iext = 1:next
    if COMPATIBILITY_MODE
      theextension = extension ;
    else
      theextension = extension{iext} ;
    end
    
    % Verif si le fichier existe bien
    if COMPATIBILITY_MODE
      lastfile = strcat(lastprob, theextension);
    else
      lastfile = lastprob ;
    end
    
    if exist(lastfile, 'file')
      EXIST_LAST = 1 ;
    end
  end  
else
  % Le fichier last.tmp, n'existe pas ou n'est pas ouvrable    
  EXIST_LAST = 0 ;
end

if ~EXIST_LAST
  lastprob = ' ' ;
  lastfile  = ' ' ;
end

% -------------------------------------------------------
% Tant que nom fichier non saisi on boucle sur la demande
% Le nom par defaut contenu dans lastprob est proposé et
% sera validé si frappe RETURN. Si on frappe '*', tous les
% fichiers comportant l'extension extension seront listés
% -------------------------------------------------------
  done = 0 ;

if COMPATIBILITY_MODE
  chain = append( message, ' [ ', lastprob, ' ]: ' ) ;
  
  while ~done
    filename = input(chain, 's');
    
    if isempty ( filename )  
    % L'utilisateur tape ENTER directement
      filename = lastprob;
      if EXIST_LAST done = 1; end
    
    elseif filename == '*'
      % L'utilisateur tape '*'. On liste les fichiers avec l'extension
	dir( strcat('*', extension) );
    else
      done = 1;
    end
  end
  
else
  done = 0 ;
  chain = append( message, ' [ ', lastfile, ' ]: ' ) ;
  
  while ~done
    filename = input(chain, 's');
    
    if isempty ( filename )  
      % L'utilisateur tape ENTER directement
      filename = lastfile;
      if EXIST_LAST done = 1; end
      
    elseif filename == '*'
      % L'utilisateur tape '*'. On liste les fichiers avec les
      % extensions possibles
      for iext = 1 : next
	dir( strcat('*', extension{iext}) );
      end
    else
      % L'utilisateur tape une chaine non vide. Celle-ci doit
      % contenir l'extension. On teste la validité du fichier.
      fid = fopen(filename, 'r') ;
      if fid >= 0 
	% Si c'est OK, c'est fini...
	done = 1; 
	fclose(fid) ;
	
	% On écrit le nom du fichier dans last.tmp
	fidlast = fopen('last.tmp', 'w') ;
	fprintf(fidlast, filename) ;
	fclose(fidlast)
      end
    end
  end
end
