% OLMOODLE_MANAGEERRRORS:
%
% Assign tolerance

function out = olmoodle_ManageErrors (errorstruct, errorcodes, textstruct)

THERE_ARE_ERRORS = numel(errorstruct) > 0 ;

% For each error detected
for ierr = 1:numel(errorstruct)

  switch errorstruct(ierr).code
   
   case errorcodes.WRONG_CODE
    fprintf (textstruct.error.WrongCode{1}, ...
	     errorstruct(ierr).line, ...
	     errorstruct(ierr).string) ;
    fprintf('\n')  ;
   
   case errorcodes.NSET_UNSPECIFIED
   
    fprintf (textstruct.error.UnspecifiedNSET{1}) ;
    fprintf('\n')  ;
   
   case errorcodes.NSET_IS_VOID
   
    fprintf (textstruct.error.VoidNSET{1}, ...
	     errorstruct(ierr).line) ;
    fprintf('\n')  ;
   
   case errorcodes.NSET_BADLY_SPECIFIED
   
    fprintf (textstruct.error.BadNSET{1}, ...
	     errorstruct(ierr).line, ...
	     errorstruct(ierr).string) ;
    fprintf('\n')  ;
    
   case errorcodes.TOL_UNSPECIFIED

    fprintf (textstruct.error.UnspecifiedTOL{1}) ;
    fprintf('\n')  ;
   
   case errorcodes.TOL_BADLY_SPECIFIED
    
    fprintf (textstruct.error.BadTOL{1}, ...
	     errorstruct(ierr).line, ...
	     errorstruct(ierr).string) ;
    fprintf('\n')  ;
    
   case errorcodes.TOL_BAD_UNIT
    
    fprintf (textstruct.error.BadUnitTOL{1}, ...
	     errorstruct(ierr).line, ...
	     errorstruct(ierr).string) ;
    fprintf('\n')  ;
    
   case errorcodes.TOL_IS_VOID
    
    fprintf (textstruct.error.VoidTOL{1}, ...
	     errorstruct(ierr).line) ;
    fprintf('\n')  ;
    
   case errorcodes.POINTS_NOT_NUMERIC

    fprintf (textstruct.error.PointsNotNumeric{1}, ...
	     errorstruct(ierr).line, ...
	     errorstruct(ierr).string) ;
    fprintf('\n')  ;
   
   case errorcodes.POINTS_NOT_INTEGER

    fprintf (textstruct.error.PointsNotInteger{1}, ...
	     errorstruct(ierr).line, ...
	     errorstruct(ierr).string) ;
    fprintf('\n')  ;

   case errorcodes.PRECISION_NOT_NUMERIC

    fprintf (textstruct.error.PrecNotNumeric{1}, ...
	     errorstruct(ierr).line, ...
	     errorstruct(ierr).string) ;
    fprintf('\n')  ;

   case errorcodes.PRECISION_NOT_INTEGER

    fprintf (textstruct.error.PrecNotInteger{1}, ...
	     errorstruct(ierr).line, ...
	     errorstruct(ierr).string) ;
    fprintf('\n')  ;

   case errorcodes.PRECISION_UNSPECIFIED

    fprintf (textstruct.error.PrecUnspecified{1}, ...
	     errorstruct(ierr).line) ;
    fprintf('\n')  ;

    
   otherwise
    error('I found unknown error code. This should not happen !') ;
  end
end

if THERE_ARE_ERRORS
  out = -1 ;
else
  out = 0 ;
end

