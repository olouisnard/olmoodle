% OLMOODLE_CREATESET :
%
% Creates all matlab variables corresponding to either fixed or
% variable input data. 
%
% The created variable name is in fact a struct my, the variable being
% stored in my.matlabname, where matlab name is the content of
% datastruct.props.matlab (this is the name defined by user in the
% Excel file). 
%
% The variable input data are built by defining equiprobable random
% values between min and max (see olmoodle_BuildListValues.m)
%
function my = olmoodle_CreateSets (genstruct, datastruct)

nset = genstruct.nset ;

%----------------------------------------------------------------------
% Define fixed values 
%----------------------------------------------------------------------
for k = 1:numel(genstruct.lists.fixedinput)  
  n = genstruct.lists.fixedinput(k) ; % number of line in global dataset
  my.(datastruct(n).props.matlab) = datastruct(n).props.value ;  
end

%----------------------------------------------------------------------
% Create sets of values for each variable input
%----------------------------------------------------------------------
for k = 1:numel(genstruct.lists.varinput)  
  n = genstruct.lists.varinput(k) ; % number of line in global dataset
  my.(datastruct(n).props.matlab) = ...
      olmoodle_BuildListValues( nset, ...
				datastruct(n).props.min, ...
				datastruct(n).props.max, ...
				datastruct(n).props.precision ) ;
  
end
