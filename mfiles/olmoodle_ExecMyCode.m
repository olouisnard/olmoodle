

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
