% OLMOODLE_GETLANGUAGES:
%
% Find the available languages for the code. This is determined by
% finding all subfolders of INSTALLPATH/data/txt, except . and ..
%
% On output:
%
% langdirs : a cell array containing all languages code (type en,
%    fr)

function langdirs = olmoodle_GetLanguages (pathstruct)


% Path of txt data
txtpath = append(pathstruct.DataPath, '/txt') ;

% Look at subdirs in data/txt paths
listing = dir(txtpath) ;

nlang = 0 ;

for n = 1:numel(listing)
  % List folder
  if listing(n).isdir
    % If it is a directory...
    contains_no_point = isempty( ...
	regexp(listing(n).name, '.*\.+.*') ...
	) ;

    if contains_no_point
      % ...and if contains no point in name, this is a language
      % directory
      nlang = nlang + 1 ;
      langdirs{nlang} = listing(n).name ;
    end
  end
end
