<?LassoScript 
	// ==================================
	/*		Comment here	*/	// ==================================

	!var_defined('gv_sql') ?
		var(
			'gv_sql' = array(
					-Database=$DBName,
					-Username=$ClientDBUsername,
					-Password=$ClientDBPassword,
					-maxRecords='all'
					)
			);

	local('requiredTags' = array
		(
			'xs_iserror',
			'LEAP_manageGlobals',
			'LEAP_manageFeatures',
			'xs_lflickr',
		)
	);
	// LOAD REQUIRED TAGS
	iterate(#requiredTags,local('t'));
		protect;
			include('/_tags/'+#t+'.lasso');
		/protect;
	/iterate;
	
	// LOAD SITE PREFS
	protect;
		LEAP_manageGlobals->populate;
		handle;
			$gv_error;
		/handle;
	/protect;

	!var_defined('gv_lflickr_key') ? var('gv_lflickr_key' = string);
	!var_defined('gv_lflickr_secret') ? var('gv_lflickr_secret' = string);
	!var_defined('gv_lflickr_token') ? var('gv_lflickr_token' = string);
	!var_defined('gv_lflickr_userid') ? var('gv_lflickr_userid' = string);	?>