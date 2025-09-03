% OLMOODLE_EXECMYCODE :
%
% Executes the user snippet code. 
%
% Before the variables constituted by the fields of myins (the latter
% are all input data, fixed or variable) are copied in simple variable
% names, to allow the user to manipulate the symbol as he wrote them
% in his/her Excel file. For example if the user declared a input
% data named "time", the operation 
%       time = myins.time 
% is performed.
%
% Afterwards the opposite is done for calculated and answer
% variables. the user output variables are affected in fields of
% myout. If the user declared a variable "flux", the operation
%       myouts.flux = flux 
% is performed
%
% Both are done by using the eval function, which is strongly
% discouraged for security reasons. Whether there is indeed a
% security fail here remains yet obscure for me...
%
% Usage:
%     myouts = olmoodle_ExecMyCode (genstruct, datastruct, myins) 
%
% On input:
%    genstruct: the general data structure
%    datastruct: the Excel data structure
%    myins: a structure with one field per input variable declared
%    by the user.
%
% On output:
%    myouts: a structure with one field per input variable declared
%    by the user. The min and max of each answer variable is a lso
%    computed in myouts.(variable).min and myouts.(variable).max

function myouts = olmoodle_ExecMyCode (genstruct, datastruct, myins) 

nset = genstruct.nset ;
zzz = zeros(nset, 1) ;

%======================================================================
% Execute matlab commands of the form :
% var = myins.var 
% for all input date (fixed and var)
%======================================================================

% Fixed data
for k = 1 : numel(genstruct.lists.fixedinput)
  n = genstruct.lists.fixedinput(k) ;
  comm = sprintf('%s = myins.%s ; ', ...
		 datastruct(n).props.matlab, ...
		 datastruct(n).props.matlab) ;
  eval(comm) ;
end

% Varying data
for k = 1 : numel(genstruct.lists.varinput)
  n = genstruct.lists.varinput(k) ;
  comm = sprintf('%s = myins.%s ; ', ...
		 datastruct(n).props.matlab, ...
		 datastruct(n).props.matlab) ;
  eval(comm) ;
end


%======================================================================
% Execute user matlab file
% In the latter, the user enters liones such as var =. This system
% allows the user to manipulate his own matlab names, withour
% adding "myin." or "myout." before. 
%======================================================================
mycode

%======================================================================
% Execute matlab commands of the form :
% myouts.var = var 
% for all output data (calculated and answers)
%======================================================================


% Matlab assignment lines for calculated inputs
for k = 1 : numel(genstruct.lists.calc)
  n = genstruct.lists.calc(k) ;
  comm = sprintf('myouts.%s.value = %s ; ', ...
		 datastruct(n).props.matlab, ...
		 datastruct(n).props.matlab) ;
  eval(comm) ;
end



% Matlab assignment lines for answers to questions
for k = 1 : numel(genstruct.lists.question)
  n = genstruct.lists.question(k) ;
  comm = sprintf('myouts.%s.value = %s ; ', ...
		 datastruct(n).props.matlab, ...
		 datastruct(n).props.matlab) ;
  eval(comm) ;
end


%======================================================================
% Compute min and maxes of answers
%======================================================================
% Matlab assignment lines for answers to questions
for k = 1 : numel(genstruct.lists.question)
  n = genstruct.lists.question(k) ;

  varname = datastruct(n).props.matlab ;

  myouts.(varname).min = min (myouts.(varname).value) ;
  myouts.(varname).max = max (myouts.(varname).value) ;
end
