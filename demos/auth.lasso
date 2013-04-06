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


	local('frob' =  xs_lflickr->flickr_auth_getFrob(-api_key=$gv_lflickr_key,-secret=$gv_lflickr_secret));		local('geturl' ='http://flickr.com/services/auth/?');

			#geturl += 'api_key='$gv_lflickr_key;
			#geturl += '&perms=read';
			#geturl += '&frob='(encode_url(#frob->find('frob')));

		local('tomd5' = $gv_lflickr_secret);
			#tomd5 += 'api_key'$gv_lflickr_key;
			#tomd5 += 'frob'(#frob->find('frob'));
			#tomd5 += 'permsread';

			#geturl += '&api_sig='(Encrypt_MD5(#tomd5));
?>
</head>

<body>
<p>Click <a href="[#geturl]">HERE</a> to authorize</p>



<p>Error: [$gv_error]</p>


</body>
</html>