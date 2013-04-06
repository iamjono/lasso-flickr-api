<?LassoScript 
	// ==================================
	/*		Install file for LEAP_Pref
	*/	// ==================================
	include('/CONFIG.lasso');	
		local('sSQL' = 'CREATE TABLE IF NOT EXISTS LEAP_Pref (
  id int(11) NOT NULL auto_increment,
  pref_name varchar(255) NOT NULL default "",
  pref_value text,
  lastUpdate timestamp NULL default NULL,
  public varchar(8) NOT NULL default "true",
  deletion_lock int(3) NOT NULL default "0",
  PRIMARY KEY  (id),
  KEY pref_name (pref_name),
  KEY public (public)
) ENGINE=MyISAM AUTO_INCREMENT=56 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS flickrcache (
  id varchar(255) NOT NULL default "",
  cache longblob NOT NULL,
  PRIMARY KEY  (id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;');
	inline(
		-Database=$DBName,
		-Username=$ClientDBUsername,
		-Password=$ClientDBPassword,
		-SQL=#sSQL);
		error_currenterror;
	/inline;?>