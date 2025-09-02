% ASKYESNO :
%
% Asks a question  and waits a n answer yes or no. On output,
% answer is 1 if answer if yes, 0 otherwise. 

function answer = askyesno (message, yesanswers, noanswers, RETURN_IS_YES)

% bBy default, return key is understood as "no"
if nargin < 4 || isempty(RETURN_IS_YES)
  RETURN_IS_YES = 0 ;
end

done = 0 ;

while ~done
  % Display message and asks for answer
  answer = input(message, 's');
  
  if isempty ( answer )  
    % User enters ENTER key
    answer = RETURN_IS_YES ;
    
    done = 1 ;
  else 
    switch answer
      
     case yesanswers
      % User enters YES
      answer = 1 ;
      done  = 1 ;
      
     case noanswers
      % User enters NO
      answer = 0 ;
      done  = 1 ;
      
     otherwise
      done = 0  ;
    end
  end
end

