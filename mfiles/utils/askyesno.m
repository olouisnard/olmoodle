% ASKYESNO :
%
% Asks a question  and waits until the user presses a key
% interpreted as  yes or no. 
%
% Usage:
%     answercode = askyesno (message, yesanswers, noanswers, RETURN_IS_YES)
% On input:
%
%   message: message to display
%
%   yesanswers:  either string or string cell containing all
%                possible strings accepted as "yes"
%
%   noanswers:  either string or string cell containing all
%                possible strings accepted as "no"
%
%   RETURN_IS_YES (optional):
%       set to 1 if you want RETURN key pressed understood as yes
%       set to 0 if you want RETURN key pressed understood as no (default)
%       set to -1 if you want to leave RETURN interpreted as
%         'other' (strict mode)
%
% On output:
%       answercode is 1    if answer if yes, 
%                     0    if answer is no; 

% an
%
% Example: a typical use may be :
%
%     askyesno('Yes or no?  ', {'Y','y'}, {'N', 'n'}, 1)

function answercode = askyesno (message, yesanswers, noanswers, RETURN_IS_YES)

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
    if RETURN_IS_YES == -1
      % We are in strict mode, thus this is unacceptable
      done = 0 ;
    elseif RETURN_IS_YES == 0 || RETURN_IS_YES == 1
      % We are not in strict mode, interpret as yes or no
      answercode = RETURN_IS_YES ;
      done = 1 ;
    else 
      % RETURN_IS_YES has bad value
      error('Bad value for input argument RETURN_IS_YES \n') ;
    end
    
  else
    switch answer
      
     case yesanswers
      % User enters YES
      answercode = 1 ;
      done  = 1 ;
      
     case noanswers
      % User enters NO
      answercode = 0 ;
      done  = 1 ;
      
     otherwise
      % Cannot exit loop if answer is neither yes nor no
      done = 0  ;
    end
  end
end

