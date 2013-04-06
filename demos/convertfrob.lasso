<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>

<head>
<title>xServe Flickr API</title>
<?LassoScript 
	// ==================================
	/*
		Usage demo for xs_lFlickr :)
		� Jonathan Guthrie 2006
	*/
	// ==================================
	var('gv_feedback' = string);
	var('gv_error' = string);
	
	

	include('/CONFIG.lasso');	
	local('requiredTags' = array
		(
			'xs_iserror',
			'LEAP_manageGlobals',
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
	local('frob' = string(action_param('frob')));
	local('newtoken' = xs_lflickr->flickr_auth_getToken(-api_key=$gv_lflickr_key,-secret=$gv_lflickr_secret,-frob=$frob));
?>
</head>

<body>

<p>Your new token is: [#newtoken->find('token')]</p>
<p>Token checks as:
<pre>
<?LassoScript 
	// store it:
	Inline(
		$gv_sql, 
		-SQL='
			UPDATE LEAP_Pref 
			SET pref_value = "'+encode_sql(#newtoken->find('token'))+'",
			lastupdate = NOW()
			WHERE pref_name = "lflickr_token" 
			LIMIT 1');
	/Inline;
	xs_lflickr->flickr.auth.checkToken(-api_key=$gv_lflickr_key,-auth_token=(#newtoken->find('token')))
?>
</pre>
</p>

<p>Feedback: [$gv_feedback]</p>
<p>Error: [$gv_error]</p>


</body>
</html>