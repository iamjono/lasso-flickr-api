<?LassoScript 
	// ==================================
	/*
		Flickr module
		-- Jono

		- to authenticate:
			if token is not valid, hit /flickr/auth.lasso
			click the URL, validate, and it will return to /flickr/convertfrob.lasso and give you a token to store.




	*/
	// ==================================
	include('/flickr/common.lasso');
	
	// ==================================
	//	Define the feature list
	// ==================================	
	var('Feature_List'=Array(
		'displayType',
		'displayID',
		'displayMethod',
		'perView'
		));

	LEAP_managefeatures->populate;
	local(
		'mygroups' = map,
		'mysets' = map
		);

	
if(var('Page_Status') == 'Admin');

	if(var('LEAP_Feature_Change') == 'YES' && $ContentID == var('Advanced_Style_Open'));
		protect;
			LEAP_managefeatures->update;
		/protect;
	/if;
	
	if(var('LEAP_Global_Change') == 'YES' && var('activeglobals')->size > 0);
		protect;
			LEAP_manageGlobals->update;
		/protect;
	/if;

	protect;
		local('authstate' = xs_lflickr->flickr_auth_checkToken(
				-api_key=$gv_lflickr_key,
				-secret=$gv_lflickr_secret,
				-auth_token=$gv_lflickr_token
			));
//		'Permissions: '#authstate->find('perms')' ';
		if(#authstate->find('error') != '');
			
			'Token not valid. Please visit the auth pages!<br>';

		/if;

		local('mygroups' = xs_lflickr->flickr_groups_pools_getGroups(
								-api_key=$gv_lflickr_key,
								-secret=$gv_lflickr_secret,
								-token=$gv_lflickr_token
							)
						);

		local('mysets' = xs_lflickr->flickr_photosets_getList(
								-api_key=$gv_lflickr_key,
								-user_id=$gv_lflickr_userid
							)
						);


		
		
		handle;
			xs_iserror;
		/handle;
	/protect;

//This is a div which will open when you click the "advanced" button on the module and allow you to edit "features"
?>

<div id="Module[$ContentID]" style="text-align:center;display:none;">

<fieldset class="LEAPAdmin" ID="Advanced"><legend class="LEAPlegend">Advanced Options</legend>
<table class="list" width="100%">
<tr>
<td valign="top" width="50%">
<table class="list">
	<form action="" method="post">
				<Input type="hidden" name="Advanced_Style_Open" value="[$ContentID]">
				<INPUT TYPE="hidden" NAME="LEAP_Feature_Change" VALUE="YES">
	<tr align="right">
		<td>Display Type: <label><Input type="radio" name="displayType" value="set" [$Feature_Map->Find('displayType') == 'set' ? ' checked']>Set</label> <label><Input type="radio" name="displayType" value="group" [$Feature_Map->Find('displayType') != 'set' ? ' checked']>Group</label></td>
	 </tr>
	<tr align="right">
		<td>Set/Group ID: <select name="displayID">
<?LassoScript
	protect; 
		iterate(#mygroups->find('photogroups'),local('x'));
			'<option value="'#x->find('id')'"';
			$Feature_Map->Find('displayID') == #x->find('id') ? ' selected';
			'>Group: '#x->find('name')' ('#x->find('photos')')</option>';
		/iterate;
		handle;
			xs_iserror;
		/handle;
	/protect;
	#mygroups->find('photogroups')->size > 0 ? '<option>---------------------</option>';
	protect; 
		iterate(#mysets->find('photosets'),local('x'));
			'<option value="'#x->find('id')'"';
			$Feature_Map->Find('displayID') == #x->find('id') ? ' selected';
			'>Set: ';
			#x->find('title')->size > 20 ? #x->find('title')->substring(1,20)+'...' | #x->find('title');
			' ('#x->find('photos')')</option>';
		/iterate;
		handle;
			xs_iserror;
		/handle;
	/protect;
?>
</select></td>
	 </tr>
	<tr align="right">
		<td>Display Method: 
<select name="displayMethod">
<option value="Lightbox1"[$Feature_Map->Find('displayMethod') == 'Lightbox1' ? ' selected']>Lightbox 1</option>
<option value="Lightbox2"[$Feature_Map->Find('displayMethod') == 'Lightbox2' ? ' selected']>Lightbox 2</option>
</select>
</td>
	 </tr>
	<tr align="right">
		<td># to Display at a time: <Input type="text" name="perView" value="[$Feature_Map->Find('perView')]"></td>
	 </tr>
	<tr align="right">
		<td><INPUT TYPE="submit" NAME="submit" VALUE="submit"></td>
	 </tr>
		</form>
	 </table>
	</td>
	
	<td valign="top" width="50%">
<table class="list">
	<form action="" method="post">
	<input type="hidden" name="activeglobals" value="lflickr_userid,lflickr_key,lflickr_secret,lflickr_token">
	<input type="hidden" name="LEAP_Global_Change" value="YES">
	<tr align="right">
		<td>Flickr User ID: <Input type="text" name="lflickr_userid" value="[$gv_lflickr_userid]"></td>
	 </tr>
	<tr align="right">
		<td>Flickr Key: <Input type="text" name="lflickr_key" value="[$gv_lflickr_key]"></td>
	 </tr>
	<tr align="right">
		<td>Flickr Secret: <Input type="text" name="lflickr_secret" value="[$gv_lflickr_secret]"></td>
	 </tr>
	<tr align="right">
		<td>Flickr Token: <Input type="text" name="lflickr_token" value="[$gv_lflickr_token]"></td>
	 </tr>
	<tr align="right">
		<td><INPUT TYPE="submit" NAME="submit" VALUE="Update Globals"></td>
	 </tr>
		</form>
	 </table>	
	</td>
</tr>
</table>
	 </fieldset>
	</div>



<?LassoScript 
	/if;
?>

<style type="text/css">
<!--
#nopad td {
	font: 11px "Lucida Grande", Verdana, Arial, sans-serif;
	padding: 1px 5px 1px 0px;
}
#nopad td:hover {
	font: 11px "Lucida Grande", Verdana, Arial, sans-serif;
	padding: 1px 5px 1px 0px;
}
.nopad td {
	font: 11px "Lucida Grande", Verdana, Arial, sans-serif;
	padding: 1px 5px 1px 0px;
}
.nopad td:hover {
	font: 11px "Lucida Grande", Verdana, Arial, sans-serif;
	padding: 1px 5px 1px 0px;
}

//-->
</style>
<link rel="stylesheet" href="/flickr/css/lightbox.css" type="text/css" media="screen" />

<script type="text/javascript" src="/flickr/js/prototype.js"></script>
<script type="text/javascript" src="/flickr/js/scriptaculous.js?load=effects"></script>
<script type="text/javascript" src="/flickr/js/lightbox.js"></script>



<?LassoScript 
		if($Feature_Map->Find('displayType') == 'set' && $Feature_Map->Find('displayID') != '');
			// get SET contents
//			local('myphotos' = 
//				xs_lflickr->flickr.photosets.getPhotos(
//					-api_key=$gv_lflickr_key,
//					-photoset_id=$Feature_Map->Find('displayID')
//					)
//				);
			local('myphotos' = xs_flickrPhoto->cache(-setid=$Feature_Map->Find('displayID'),-api_key=$gv_lflickr_key,-token=$gv_lflickr_token));
				
		else($Feature_Map->Find('displayType') == 'group' && $Feature_Map->Find('displayID') != '');
			// get GROUP contents
//			local('myphotos' = 
//				xs_lflickr->flickr.groups.pools.getPhotos(
//					-api_key=$gv_lflickr_key,
//					-group_id=$Feature_Map->Find('displayID')
//					)
//				);
			local('myphotos' = xs_flickrPhoto->cache(-groupid=$Feature_Map->Find('displayID'),-api_key=$gv_lflickr_key,-token=$gv_lflickr_token));

		/if;
//#myphotos->find('photos')->get(1)->id;'<br>';
//#myphotos->find('photos')->get(1)->secret;'<br>';
//#myphotos->find('photos')->get(1)->server;'<br>';
//
//xs_flickrPhoto->url(-isize='',-obj=#myphotos->find('photos')->get(1));

if($Feature_Map->Find('displayMethod') == 'Lightbox1');
	'<p>Lightbox 1 has no borders and has the related grouping done in lightbox as well</p>';
	iterate(#myphotos->find('photos'),local('thisphoto'));
		'
		<a href="'xs_flickrPhoto->url(-isize='',-obj=#thisphoto)'" rel="lightbox[session]" title="'#thisphoto->title'">
		<img src="'xs_flickrPhoto->url(-isize='s',-obj=#thisphoto)'" border="0" style="margin: 0 3px 3px 0"></a>';
		
		loop_count >= $Feature_Map->Find('perView') ? loop_abort;
	/iterate;
	
else($Feature_Map->Find('displayMethod') == 'Lightbox2');
	'<p>Lightbox 2 has grey borders and has NO related grouping</p>';
	iterate(#myphotos->find('photos'),local('thisphoto'));
		'
		<a href="'xs_flickrPhoto->url(-isize='',-obj=#thisphoto)'" rel="lightbox" title="'#thisphoto->title'">
		<img src="'xs_flickrPhoto->url(-isize='s',-obj=#thisphoto)'" border="0" style="border: 1px solid grey; margin: 0 3px 3px 0"></a>';
		
		loop_count >= $Feature_Map->Find('perView') ? loop_abort;
	/iterate;
	
/if;
'<hr>Errors: <pre>';
	$gv_error;
	'</pre>';
?>
