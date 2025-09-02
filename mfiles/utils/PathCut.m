% PATHCUT :
%
% Cuts a path into pieces and returns the elementary pieces one by
% one, as long as the cumulative paths, both in cell arrays.  If there
% is a filename on input, it is replaced by the containing directory.
%
% Usage :
% """""
%      [IncrementalPath, PiecePath]  = PathCut (fullpath)
%
% For example : with /Users/louisnar/machin/bidule in input, the
% function returns :
%
% in IncrementalPath :
% 
%    {'bidule'                      }
%    {'machin/bidule'               }
%    {'louisnar/machin/bidule'      }
%    {'Users/louisnar/machin/bidule'}
%
% in PiecePath :
%
%    {'bidule'  }
%    {'machin'  }
%    {'louisnar'}
%    {'Users'   }
%
% in NormalPath :
%
%    {'Users/louisnar/machin'}
%    {'Users/louisnar'}
%    {'Users'}
%
% The latter would correspond to what would be contained in .., ../..,
% ../../.. and so on
%
% A typical usage is :
%      [IncrementalPath, PiecePath, NormalPath]  = PathCut(pwd)
%
% but if input argument is omitted, the current directory is the
% current one.


function [IncrementalPath, InvPiecePath, NormalPath]  = PathCut (fullpath)

if nargin < 1
  fullpath = pwd ;
end

% Test if input argument is directory or file
IS_DIRECTORY = isfolder (fullpath) ;

slashcar = filesep ; % '/' or '\'

% Split the fullpath in pieces. Each piece is a subpath part.
tmp = split(fullpath, filesep ) ;

npieces = numel(tmp) - 1 ; % to remove the first '/'
PiecePath = tmp(2:end) ; % To remove corresponding first blank field

% If notdirectory, remove last part which is filename

if ~IS_DIRECTORY
  npieces = npieces - 1 ;
  PiecePath = PiecePath(1:npieces) ;
end

% Compute incremental path, starting from rightest part
InvPiecePath = flipud(PiecePath) ;


% Create a 6 lines x 1 column empty character array
IncrementalPath = repmat({''}, npieces, 1) ;

CurrentPath = '' ;
% Create incremental array
for n = 1 : npieces
  CurrentPath = [InvPiecePath{n}, CurrentPath] ;
  IncrementalPath(n) = {CurrentPath} ;
  CurrentPath = [slashcar, CurrentPath] ;
end

CurrentPath = slashcar ;
% Create normal incremental array
NormalPath = repmat({''}, npieces - 1, 1) ;
for n = 1 : npieces - 1
  CurrentPath = [CurrentPath, PiecePath{n}] ;
  NormalPath(n) = {CurrentPath} ;
  CurrentPath = [CurrentPath, slashcar] ;
end

NormalPath = flipud(NormalPath) ;
