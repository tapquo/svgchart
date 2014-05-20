Utils =

  mergeOptions: (default_options = {}, options = {}) ->
  	default_options_clone = JSON.parse(JSON.stringify(default_options)) 
  	default_options_clone[key] = value for key, value of options
  	default_options_clone


