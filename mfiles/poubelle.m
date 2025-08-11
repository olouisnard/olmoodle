if isnumeric(opts.intervalspecs) 
  % If numeric
  switch opts.intervalspecs
   
   case -1
    DISPLAY_INTERVAL = 0 ;
   
   case 0
    DISPLAY_INTERVAL = 1 ;
    DISPLAY_POOR_INTERVAL = 1 ;

   case 1
    DISPLAY_INTERVAL = 1 ;
    DISPLAY_RICH_INTERVAL = 1 ;
    intervalspecs = DEFAULT_INTERVALSPECS ;

   otherwise 
    warning('Wrong integer value for intervalspecs. I set behaviour to no interval' ) ;
    DISPLAY_INTERVAL = 0 ;
    out = -1 ;
  end
  
elseif ischar(opts.intervalspecs) || isstring(opts.intervalspecs)
  % If character or string (allows string arguments defined either
  % as "blah blah" or as 'blah blah')
  
  DISPLAY_INTERVAL = 1 ;
  DISPLAY_PROVIDED_INTERVAL = 1 ;
  
elseif isstruct(opts.intervalspecs)
  intervalspecs = opts.intervalspecs ;
  DISPLAY_INTERVAL = 1 ;
  DISPLAY_RICH_INTERVAL = 1 ;
  
else
  % Other => error.
  warning('Wrong type for intervalspecs. I set behaviour to no interval' ) ;
  DISPLAY_INTERVAL = 0 ;  
  out = -2 ;
end
