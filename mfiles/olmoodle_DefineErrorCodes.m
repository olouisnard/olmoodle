% OLMOODLE_DEFINEERRORCODES:
%
% Define error codes corresponding to errors that can be found in
% Excel file

function errorcodes = olmoodle_DefineErrorCodes()

%----------------------------------------------------------------------
% Error codes 
%----------------------------------------------------------------------
errorcodes.NSET_BADLY_SPECIFIED = 1 ;
errorcodes.NSET_UNSPECIFIED = 2 ;
errorcodes.NSET_IS_VOID = 8 ;

errorcodes.WRONG_CODE = 3 ;

errorcodes.POINTS_NOT_INTEGER = 4 ;
errorcodes.POINTS_NOT_NUMERIC = 5 ;

errorcodes.TOL_BADLY_SPECIFIED = 6 ; 
errorcodes.TOL_UNSPECIFIED = 7 ; 
errorcodes.TOL_IS_VOID = 9 ; 
errorcodes.TOL_BAD_UNIT = 13 ; 

errorcodes.PRECISION_NOT_INTEGER = 10 ; 
errorcodes.PRECISION_NOT_NUMERIC = 11 ; 
errorcodes.PRECISION_UNSPECIFIED = 12 ; 


errorcodes.VALUE_NOT_NUMERIC = 14 ; 

errorcodes.TEXT_IS_NUMERIC = 15 ;

errorcodes.UNIT_FORGOT_SEPARATOR = 16 ;
errorcodes.UNIT_NO_LETTER = 17 ;
errorcodes.UNIT_BAD_EXPONENT = 18 ;

errorcodes.MOODLECAT_UNSPECIFIED = 19 ;
