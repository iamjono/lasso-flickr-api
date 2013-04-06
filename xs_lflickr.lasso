<?LassoScript 
	// ==================================
	/*		xs_lFlickr :)
		Jonathan Guthrie 2006
		
		http://www.flickr.com/services/api/response.json.html	*/	// ==================================
define xs_lFlickr => type {
	
	// ==================================
	// auth
	// ==================================

	public flickr_auth_checkToken(
		api_key::sting,
		auth_token::sting,
		secret::sting) => {
		// Returns the credentials attached to an authentication token.
	
		local('out' = map);
		local('geturl' ='http://www.flickr.com/services/rest/?method=flickr.auth.checkToken&format=rest');
			#geturl += '&api_key='#api_key;
			#geturl += '&api_sig='(Encrypt_MD5(#secret+'api_key'+#api_key+'auth_token'+#auth_token+'formatrestmethodflickr.auth.checkToken'));
			#geturl += '&auth_token='#auth_token;
		local('this' = xml(include_url(#geturl)));
		#this->extract('normalize-space(//rsp/@stat)') == 'fail' ? #out->insert('error' = self->geterror(-err=#this))

		#out->insert('token' = (#this->extract('normalize-space(//token/text())')));
		#out->insert('perms' = (#this->extract('normalize-space(//perms/text())')));

		return #out
	}
	
	
	define_tag('flickr_auth_getFrob',
		-required='api_key',
		-required='secret',
		-description='');
	//Returns a frob to be used during authentication. This method call must be signed.
		local('temp' = string);
		local('geturl' ='http://www.flickr.com/services/rest/?method=flickr.auth.getFrob&format=rest');
			#geturl += '&api_key='#api_key;
			#geturl += '&api_sig='(Encrypt_MD5(#secret+'api_key'+#api_key+'formatrestmethodflickr.auth.getFrob'));
//			#geturl += '&api_sig='(Encrypt_MD5(#secret+'api_key'+#api_key+'methodflickr.auth.getFrob'));
		local('this' = xml(include_url(#geturl)));
		local('out' = map);
		(#this->extract('normalize-space(//rsp/@stat)') == 'fail')? #out->insert('error' = (self->geterror(-err=#this)));
		#out->insert('frob' = (#this->extract('normalize-space(//frob/text())')));
		return #out
	}
	
	
	
	define_tag('flickr_auth_getFullToken',
		-required='api_key',
		-required='mini_token',
		-description='');
	//Get the full authentication token for a mini-token. This method call must be signed.
		// ONLY FOR MOBILE AUTH
	}
	
	
	define_tag('flickr_auth_getToken',
		-required='api_key',
		-required='secret',
		-required='frob',
		-description='');
	//Returns the auth token for the given frob, if one has been attached. This method call must be signed.

		local('out' = map);
		local('temp' = string);
		local('geturl' ='http://www.flickr.com/services/rest/');
			#geturl += '?method=flickr.auth.getToken';
			#geturl += '&format=rest';
			#geturl += '&api_key='#api_key;
			#geturl += '&frob='#frob;

		local('tomd5' = #secret);
			#tomd5 += 'api_key'#api_key;
			#tomd5 += 'formatrest';
			#tomd5 += 'frob'#frob;
			#tomd5 += 'methodflickr.auth.getToken';

			#geturl += '&api_sig='(Encrypt_MD5(#tomd5));
		local('this' = xml(include_url(#geturl)));
		(#this->extract('normalize-space(//rsp/@stat)') == 'fail')? #out->insert('error' = (self->geterror(-err=#this))+': '+#geturl);
		#out->insert('token' = (#this->extract('normalize-space(//token/text())')));
		return #out


	}

	

	// ==================================
	// blogs
	// ==================================

	define_tag('flickr_blogs.getList',
		-description='Not implemented yet');
	}
	define_tag('flickr_blogs.postPhoto',
		-description='Not implemented yet');
	}


	// ==================================
	// contacts
	// ==================================

	define_tag('flickr_contacts.getList',
		-description='Not implemented yet');
	}
	define_tag('flickr_contacts.getPublicList',
		-description='Not implemented yet');
	}

	// ==================================
	// favorites
	// ==================================

	define_tag('flickr_favorites.add',
		-description='Not implemented yet');
	}
	define_tag('flickr_favorites.getList',
		-description='Not implemented yet');
	}
	define_tag('flickr_favorites.getPublicList',
		-description='Not implemented yet');
	}
	define_tag('flickr_favorites.remove',
		-description='Not implemented yet');
	}


	// ==================================
	// groups
	// ==================================

	define_tag('flickr_groups.browse',
		-required='api_key',
		-required='secret',
		-required='token',
		-optional='cat_id',
		-description='Browse the group category tree, finding groups and sub-categories.');
		
		local('out' = map);
		local('temp' = string);
		local('groupsarray' = array);
		local('geturl' ='http://www.flickr.com/services/rest/?method=flickr.groups.browse&format=rest&');
			#geturl += '&api_key='#api_key;
			local('concat' = '');
			if(local_defined('cat_id'));
				#geturl += '&cat_id='#cat_id;
				#concat = 'cat_id'#cat_id;
			else;
				#geturl += '&cat_id=';
				local('concat' = 'cat_id');
			/if;
		 	#geturl += '&auth_token='#token;
			#geturl += '&api_sig='(Encrypt_MD5(#secret+'api_key'+#api_key+'auth_token'+#token+#concat+'formatrestmethodflickr.groups.browse'));

		local('this' = xml(include_url(#geturl)));
		(#this->extract('normalize-space(//rsp/@stat)') == 'fail')? return(self->geterror(-err=#this));
		$gv_error += #this;
		return(#this);
	}
	
	
	define_tag('flickr_groups.getInfo',
		-description='Not implemented yet');
	}
	define_tag('flickr_groups.search',
		-description='Not implemented yet');
	}

	// ==================================
	// groups.pools
	// ==================================

	define_tag('flickr_groups.pools.add',
		-description='Not implemented yet');
	}
	define_tag('flickr_groups.pools.getContext',
		-description='Not implemented yet');
	}
	
	define_tag('flickr_groups.pools.getGroups',
		-required='api_key',
		-required='secret',
		-required='token',
		-description='Returns a list of groups to which you can add photos');
		
		
		local('out' = map);
		local('temp' = string);
		local('photogrouparray' = array);
		
//		local('this' = xml(include_url('http://www.flickr.com/services/rest/?method=flickr.groups.pools.getGroups&format=rest&api_key='#api_key)));
		local('geturl' ='http://www.flickr.com/services/rest/?method=flickr.groups.pools.getGroups&format=rest&');
			#geturl += '&api_key='#api_key;
		 	#geturl += '&auth_token='#token;
			#geturl += '&api_sig='(Encrypt_MD5(#secret+'api_key'+#api_key+'auth_token'+#token+'formatrestmethodflickr.groups.pools.getGroups'));
//return(#geturl);

		local('this' = xml(include_url(#geturl)));
		(#this->extract('normalize-space(//rsp/@stat)') == 'fail')? return(self->geterror(-err=#this));
		
		// get photo sets
		
		local('photogroups' = #this->extract('//groups/group'));
		loop(#photogroups->size);
			#temp = #photogroups->get(loop_count);
			local('thismap' = map);
			local('item' = string);

			#thismap->insert('id' = (#temp->extract('normalize-space(//group['+loop_count+']/@nsid)')));
			#thismap->insert('name' = (#temp->extract('normalize-space(//group['+loop_count+']/@name)')));
			#thismap->insert('photos' = (#temp->extract('normalize-space(//group['+loop_count+']/@photos)')));
			
			#photogrouparray->insert(#thismap);
		/loop;
		#out->insert('photogroups' = #photogrouparray);

		return #out


	}
	
	define_tag('flickr_groups.pools.getPhotos',
		-required='api_key',
		-required='group_id',
		-optional='token',
		-optional='tags',
		-optional='user_id',
		-optional='extras',
		-optional='per_page',
		-optional='page',
		-description='Returns a list of pool photos for a given group, 
		based on the permissions of the group and the user logged in (if any).');
		/*
		api_key (Required)
			Your API application key. See here for more details.
		group_id (Required)
			The id of the group who's pool you which to get the photo list for.
		tags (Optional)
			A tag to filter the pool with. At the moment only one tag at a time is supported.
		user_id (Optional)
			The nsid of a user. Specifiying this parameter will retrieve for you only those photos that the user has contributed to the group pool.
		extras (Optional)
			A comma-delimited list of extra information to fetch for each returned record. Currently supported fields are: license, date_upload, date_taken, owner_name, icon_server, original_format, last_update.
		per_page (Optional)
			Number of photos to return per page. If this argument is omitted, it defaults to 100. The maximum allowed value is 500.
		page (Optional)
			The page of results to return. If this argument is omitted, it defaults to 1.
		*/
		local('out' = map);
		local('temp' = string);
		local('photoarray' = array);
		local('geturl' ='http://www.flickr.com/services/rest/?method=flickr.groups.pools.getPhotos&format=rest&');
			#geturl += '&api_key='#api_key;
			#geturl += '&group_id='#group_id;
			(local_defined('tags'))? #geturl += '&tags='#tags;
			(local_defined('user_id'))? #geturl += '&user_id='#user_id;
			(local_defined('extras'))? #extras += '&extras='#extras;
			(local_defined('per_page'))? #geturl += '&per_page='#per_page;
			(local_defined('page'))? #geturl += '&page='#page;
		 	(local_defined('token'))? #geturl += '&auth_token='#token;
//return(#geturl); 	
		local('this' = xml(include_url(#geturl)));
		(#this->extract('normalize-space(//rsp/@stat)') == 'fail')? return(self->geterror(-err=#this));
		
		/*
		<photos page="1" pages="1" perpage="1" total="1">
			<photo 
				id="2645" 
				owner="12037949754@N01" 
				title="36679_o"
				secret="a9f4a06091" 
				server="2"
				ispublic="1" 
				isfriend="0" 
				isfamily="0"
				ownername="Bees / ?" 
				dateadded="1089918707" /> 
		</photos>
		*/
		#out->insert('page' = (#this->extract('normalize-space(//photos/@page)')));
		#out->insert('pages' = (#this->extract('normalize-space(//photos/@pages)')));
		#out->insert('perpage' = (#this->extract('normalize-space(//photos/@perpage)')));
		#out->insert('total' = (#this->extract('normalize-space(//photos/@toyal)')));
		loop(#this->extract('//photo')->size);
			local('thisphoto' = xs_flickrPhoto);
			local('item' = string);

			#thisphoto->id = (#this->extract('normalize-space(//photo['+loop_count+']/@id)'));
			#thisphoto->owner = (#this->extract('normalize-space(//photo['+loop_count+']/@owner)'));
			#thisphoto->title = (#this->extract('normalize-space(//photo['+loop_count+']/@title)'));
			#thisphoto->secret = (#this->extract('normalize-space(//photo['+loop_count+']/@secret)'));
			#thisphoto->server = (#this->extract('normalize-space(//photo['+loop_count+']/@server)'));
			#thisphoto->ispublic = (#this->extract('normalize-space(//photo['+loop_count+']/@ispublic)'));
			#thisphoto->isfriend = (#this->extract('normalize-space(//photo['+loop_count+']/@isfriend)'));
			#thisphoto->isfamily = (#this->extract('normalize-space(//photo['+loop_count+']/@isfamily)'));
			#thisphoto->ownername = (#this->extract('normalize-space(//photo['+loop_count+']/@ownername)'));
			#thisphoto->dateadded = (#this->extract('normalize-space(//photo['+loop_count+']/@dateadded)'));

			#photoarray->insert(#thisphoto);
		/loop;
		#out->insert('photos' = #photoarray);

		return #out
	}
	define_tag('flickr_groups.pools.remove',
		-description='Not implemented yet');
	}

	// ==================================
	// interestingness
	// ==================================

	define_tag('flickr_interestingness.getList',
		-description='Not implemented yet');
	}

	// ==================================
	// people
	// ==================================

	define_tag('flickr_people.findByEmail',
		-description='Not implemented yet');
	}
	define_tag('flickr_people.findByUsername',
		-description='Not implemented yet');
	}
	define_tag('flickr_people.getInfo',
		-description='Not implemented yet');
	}
	define_tag('flickr_people.getPublicGroups',
		-description='Not implemented yet');
	}
	define_tag('flickr_people.getPublicPhotos',
		-description='Not implemented yet');
	}
	define_tag('flickr_people.getUploadStatus',
		-description='Not implemented yet');
	}

	// ==================================
	// photos
	// ==================================

	define_tag('flickr_photos.addTags',
		-description='Not implemented yet');
	}
	define_tag('flickr_photos.delete',
		-description='Not implemented yet');
	}
	define_tag('flickr_photos.getAllContexts',
		-description='Not implemented yet');
	}
	define_tag('flickr_photos.getContactsPhotos',
		-description='Not implemented yet');
	}
	define_tag('flickr_photos.getContactsPublicPhotos',
		-description='Not implemented yet');
	}
	define_tag('flickr_photos.getContext',
		-description='Not implemented yet');
	}
	define_tag('flickr_photos.getCounts',
		-description='Not implemented yet');
	}
	define_tag('flickr_photos.getExif',
		-description='Not implemented yet');
	}
	define_tag('flickr_photos.getInfo',
		-description='Not implemented yet');
	}
	define_tag('flickr_photos.getNotInSet',
		-description='Not implemented yet');
	}
	define_tag('flickr_photos.getPerms',
		-description='Not implemented yet');
	}
	define_tag('flickr_photos.getRecent',
		-description='Not implemented yet');
	}
	define_tag('flickr_photos.getSizes',
		-description='Not implemented yet');
	}
	define_tag('flickr_photos.getUntagged',
		-description='Not implemented yet');
	}
	define_tag('flickr_photos.recentlyUpdated',
		-description='Not implemented yet');
	}
	define_tag('flickr_photos.removeTag',
		-description='Not implemented yet');
	}
	define_tag('flickr_photos.search',
		-description='Not implemented yet');
	}
	define_tag('flickr_photos.setDates',
		-description='Not implemented yet');
	}
	define_tag('flickr_photos.setMeta',
		-description='Not implemented yet');
	}
	define_tag('flickr_photos.setPerms',
		-description='Not implemented yet');
	}
	define_tag('flickr_photos.setTags',
		-description='Not implemented yet');
	}

	// ==================================
	// photos.comments
	// ==================================

	define_tag('flickr_photos.comments.addComment',
		-description='Not implemented yet');
	}
	define_tag('flickr_photos.comments.deleteComment',
		-description='Not implemented yet');
	}
	define_tag('flickr_photos.comments.editComment',
		-description='Not implemented yet');
	}
	define_tag('flickr_photos.comments.getList',
		-description='Not implemented yet');
	}

	// ==================================
	// photos.licenses
	// ==================================

	define_tag('flickr_photos.licenses.getInfo',
		-description='Not implemented yet');
	}
	define_tag('flickr_photos.licenses.setLicense',
		-description='Not implemented yet');
	}

	// ==================================
	// photos.notes
	// ==================================

	define_tag('flickr_photos.notes.add',
		-description='Not implemented yet');
	}
	define_tag('flickr_photos.notes.delete',
		-description='Not implemented yet');
	}
	define_tag('flickr_photos.notes.edit',
		-description='Not implemented yet');
	}

	// ==================================
	// photos.transform
	// ==================================

	define_tag('flickr_photos.transform.rotate',
		-description='Not implemented yet');
	}

	// ==================================
	// photos.upload
	// ==================================

	define_tag('flickr_photos.upload.checkTickets',
		-description='Not implemented yet');
	}

	// ==================================
	// photosets
	// ==================================

	define_tag('flickr_photosets.addPhoto',
		-description='Not implemented yet');
	}
	define_tag('flickr_photosets.create',
		-description='Not implemented yet');
	}
	define_tag('flickr_photosets.delete',
		-description='Not implemented yet');
	}
	define_tag('flickr_photosets.editMeta',
		-description='Not implemented yet');
	}
	define_tag('flickr_photosets.editPhotos',
		-description='Not implemented yet');
	}
	define_tag('flickr_photosets.getContext',
		-description='Not implemented yet');
	}
	define_tag('flickr_photosets.getInfo',
		-description='Not implemented yet');
	}
	
	define_tag('flickr_photosets.getList',
		-required='api_key',
		-required='user_id',
		-description='Returns the photosets belonging to the specified user.');
		
		local('out' = map);
		local('temp' = string);
		local('photosetarray' = array);
		local('this' = xml(include_url('http://www.flickr.com/services/rest/?method=flickr.photosets.getList&format=rest&user_id='+#user_id+'&api_key='+#api_key)));

		(#this->extract('normalize-space(//rsp/@stat)') == 'fail')? return(self->geterror(-err=#this));
		
		// get photo sets
		
		local('photosets' = #this->extract('//photoset'));
		loop(#photosets->size);
			#temp = #photosets->get(loop_count);
			local('thismap' = map);
			local('item' = string);

			#thismap->insert('id' = (#temp->extract('normalize-space(//photoset['+loop_count+']/@id)')));
			#thismap->insert('primary' = (#temp->extract('normalize-space(//photoset['+loop_count+']/@primary)')));
			#thismap->insert('secret' = (#temp->extract('normalize-space(//photoset['+loop_count+']/@secret)')));
			#thismap->insert('server' = (#temp->extract('normalize-space(//photoset['+loop_count+']/@server)')));
			#thismap->insert('photos' = (#temp->extract('normalize-space(//photoset['+loop_count+']/@photos)')));
			#thismap->insert('title' = (#temp->extract('normalize-space(//photoset['+loop_count+']/title/text())')));
			#thismap->insert('description' = (#temp->extract('normalize-space(//photoset['+loop_count+']/description/text())')));

			#photosetarray->insert(#thismap);
		/loop;
		#out->insert('photosets' = #photosetarray);

		return #out
	}
	


	define_tag('flickr_photosets.getPhotos',
		-required='api_key',
		-required='photoset_id',
		-optional='extras',
		-optional='privacy_filter',
		-description='Get the list of photos in a set');
		/*
		extras (Optional)
			A comma-delimited list of extra information to fetch for each returned record. 
			Currently supported fields are: 
				license, date_upload, date_taken, owner_name, icon_server, original_format, last_update.
		privacy_filter (Optional)
			Return photos only matching a certain privacy level. 
			This only applies when making an authenticated call to view a photoset you own. 
			Valid values are:
			1 public photos
			2 private photos visible to friends
			3 private photos visible to family
			4 private photos visible to friends & family
			5 completely private photos
		*/
		local('out' = map);
		local('temp' = string);
		local('photoarray' = array);
		local('this' = xml(include_url('http://www.flickr.com/services/rest/?method=flickr.photosets.getPhotos&format=rest&photoset_id='+#photoset_id+'&api_key='+#api_key)));

		(#this->extract('normalize-space(//rsp/@stat)') == 'fail')? return(self->geterror(-err=#this));
		
		loop(#this->extract('//photo')->size);
			local('thisphoto' = xs_flickrPhoto);
			local('item' = string);

			#thisphoto->id = #this->extract('normalize-space(//photo['+loop_count+']/@id)')
			#thisphoto->secret = (#this->extract('normalize-space(//photo['+loop_count+']/@secret)'));
			#thisphoto->server = (#this->extract('normalize-space(//photo['+loop_count+']/@server)'));
			#thisphoto->title = (#this->extract('normalize-space(//photo['+loop_count+']/@title)'));
			#thisphoto->isprimary = (#this->extract('normalize-space(//photo['+loop_count+']/@isprimary)'));

			#photoarray->insert(#thisphoto);
		/loop;
		#out->insert('photos' = #photoarray);

		return #out
		
	}
	
	
	
	
	define_tag('flickr_photosets.orderSets',
		-description='Not implemented yet');
	}
	define_tag('flickr_photosets.removePhoto',
		-description='Not implemented yet');
	}

	// ==================================
	// photosets.comments
	// ==================================

	define_tag('flickr_photosets.comments.addComment',
		-description='Not implemented yet');
	}
	define_tag('flickr_photosets.comments.deleteComment',
		-description='Not implemented yet');
	}
	define_tag('flickr_photosets.comments.editComment',
		-description='Not implemented yet');
	}
	define_tag('flickr_photosets.comments.getList',
		-description='Not implemented yet');
	}

	// ==================================
	// reflection
	// ==================================

	define_tag('flickr_reflection.getMethodInfo',
		-description='Not implemented yet');
	}
	define_tag('flickr_reflection.getMethods',
		-description='Not implemented yet');
	}

	// ==================================
	// tags
	// ==================================

	define_tag('flickr_tags.getListPhoto',
		-description='Not implemented yet');
	}
	define_tag('flickr_tags.getListUser',
		-description='Not implemented yet');
	}
	define_tag('flickr_tags.getListUserPopular',
		-description='Not implemented yet');
	}
	define_tag('flickr_tags.getRelated',
		-description='Not implemented yet');
	}

	// ==================================
	// test
	// ==================================

	define_tag('flickr_test.echo',
		-required='api_key',
		-description='
			A testing method which echos all paramaters back in the response.
			Returns a map of values
		');
		local('out' = map);
		local('temp' = string);
		local('this' = xml(include_url('http://www.flickr.com/services/rest/?method=flickr.test.echo&format=rest&foo=bar&api_key='+#api_key)));
		
		#temp = (#this->extract('//method/text()'));
		(#temp->size > 0)? #out->insert('method' = #temp->get(1)) | #out->insert('method' = string);
		
		#temp = (#this->extract('//foo/text()'));
		(#temp->size > 0)? #out->insert('foo' = #temp->get(1)) | #out->insert('foo' = string);
		return #out
	}
	
	
	define_tag('flickr_test.login',
		-description='Not implemented yet');
	}
	define_tag('flickr_test.null',
		-description='Not implemented yet');
	}

	// ==================================
	// urls
	// ==================================

	define_tag('flickr_urls.getGroup',
		-description='Not implemented yet');
	}
	define_tag('flickr_urls.getUserPhotos',
		-description='Not implemented yet');
	}
	define_tag('flickr_urls.getUserProfile',
		-description='Not implemented yet');
	}
	define_tag('flickr_urls.lookupGroup',
		-description='Not implemented yet');
	}
	define_tag('flickr_urls.lookupUser',
		-description='Not implemented yet');
	}

 
 	// ==================================
	// PROCESS ERROR (REST)
	// ==================================
    define_tag('geterror',-required='err');
		local('temp' = string);
		#temp = (#err->extract('normalize-space(//err/@msg)'));
		(#temp->type == 'array' && #temp->size > 0)? return(#temp->get(1)) | return(#temp);
    }
/define_type;

define_type('flickrPhoto',
		-namespace='xs_',
		-Priority='replace',
		'map',
		-description='Possible values: s,t,m,(null),b,o. See http://www.flickr.com/services/api/misc.urls.html for a full list');
		local(	'id' = string,
				'secret' = string,
				'server' = string,
				'title' = string,
				'isprimary' = string,
				'owner' = string,
				'ispublic' = string,
				'isfriend' = string,
				'isfamily' = string,
				'ownername' = string,
				'dateadded' = string);
/*
s	small square 75x75
t	thumbnail, 100 on longest side
m	small, 240 on longest side
-	medium, 500 on longest side
b	large, 1024 on longest side (only exists for very large original images)
o	original image, either a jpg, gif or png, depending on source format
*/
	    define_tag('onCreate',
    		-Optional='id', -Type='string',
    		-Optional='secret', -Type='string',
    		-Optional='server', -Type='string',
    		-Optional='title', -Type='string',
    		-Optional='isprimary', -Type='string',
    		-Optional='owner', -Type='string',
    		-Optional='ispublic', -Type='string',
    		-Optional='isfriend', -Type='string',
    		-Optional='isfamily', -Type='string',
    		-Optional='ownername', -Type='string',
    		-Optional='dateadded', -Type='string');
    		
            (local_defined('id')) ? 		self->'id'=#id; 
            (local_defined('secret')) ? 	self->'secret'=#secret;
            (local_defined('server')) ? 	self->'server'=#server; 
            (local_defined('title')) ? 		self->'title'=#title; 
            (local_defined('isprimary')) ? 	self->'isprimary'=#isprimary; 
            (local_defined('owner')) ? 		self->'owner'=#owner; 
            (local_defined('ispublic')) ? 	self->'ispublic'=#ispublic; 
            (local_defined('isfriend')) ? 	self->'isfriend'=#isfriend; 
            (local_defined('isfamily')) ? 	self->'isfamily'=#isfamily; 
            (local_defined('ownername')) ? 	self->'ownername'=#ownername; 
            (local_defined('dateadded')) ? 	self->'dateadded'=#dateadded; 
	    }
	    define_tag('url',
	    		-required='isize',-type='string',
	    		-required='obj'
	    		);
	    	local('out' = 
	    		'http://static.flickr.com/'+
	    		(#obj->server)+
	    		'/'+
	    		(#obj->id)+
	    		'_'+
	    		(#obj->secret)
	    		);
	    	(#isize->size > 0)? #out += '_'#isize;
	    	#out += '.jpg';
	    	return #out
	    }


		define_tag('cache',
			-required='api_key',
			-required='token',
			-Optional='groupid',
			-Optional='setid'
			);

			!(local_defined('groupid')) ? local('groupid' = string);
			!(local_defined('setid')) ? local('setid' = string);
			
			local('out' = map);
			if(#setid != '');
	
				local('sSQL' = 'SELECT * FROM flickrcache WHERE id = "'+(encode_sql(#setid))+'" LIMIT 1');
				inline(
					$gv_sql,
					-SQL=#sSQL);
					xs_iserror;
					if(found_count < 1);
						protect;
							#out = xs_lflickr->flickr.photosets.getPhotos(
													-api_key=#api_key,
													-photoset_id=#setid
													);
							#sSQL = 'INSERT INTO flickrcache (id,cache) VALUES ("'encode_sql(#setid)'","'encode_sql(serialize(#out))'")';
							inline(
								$gv_sql,
								-SQL=#sSQL);
								xs_iserror;
							/inline;
							handle;
								xs_iserror;
							/handle;
						/protect;
					else;
						records;
							protect;
								local('tempXML' = map);
								#tempXML->Unserialize(field('cache'));
								#out = #tempXML;
								handle;
									xs_iserror;
								/handle;
							/protect;
						/records;
					/if;
				/inline;
				
				
			else(#groupid != '');
	
				local('sSQL' = 'SELECT * FROM flickrcache WHERE id = "'+(encode_sql(#groupid))+'" LIMIT 1');
				inline(
					$gv_sql,
					-SQL=#sSQL);
					xs_iserror;
					if(found_count < 1);
						protect;
//			local('myphotos' = 
//				xs_lflickr->flickr.groups.pools.getPhotos(
//					-api_key=$gv_lflickr_key,
//					-group_id=$Feature_Map->Find('displayID')
//					)
//				);
							#out = xs_lflickr->flickr.groups.pools.getPhotos(
									-api_key=#api_key,
									-group_id=#groupid
									);
							#sSQL = 'INSERT INTO flickrcache (id,cache) VALUES ("'encode_sql(#groupid)'","'encode_sql(serialize(#out))'")';
							inline(
								$gv_sql,
								-SQL=#sSQL);
								xs_iserror;
							/inline;
							handle;
								xs_iserror;
							/handle;
						/protect;
					else;
						records;
							protect;
								local('tempXML' = map);
								#tempXML->Unserialize(field('cache'));
								#out = #tempXML;
								handle;
									xs_iserror;
								/handle;
							/protect;
						/records;
					/if;
				/inline;
			/if;
			
			return #out
		}  

}
?>