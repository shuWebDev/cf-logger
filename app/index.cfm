<cfscript>
	// NOTE:
	//	For local development testing, check to make sure you have the database mapped.
	//	If it isn't mapped, map it...
	try {
		adminstrator = new CFIDE.adminapi.administrator();
		adminstrator.login("password"); // local CF Admin password
		// writeDump(var=adminstrator, expand=false);
		datasource = new CFIDE.adminapi.datasource();
		// writeDump(var=datasource, expand=false);
		datasourceMappings = datasource.getDatasources();

		for ( mapping in datasourceMappings ) {
			// writeOutput('<p>Mapping: ' & mapping & '</p>');
			if ( !findNoCase('commonspot-external', mapping) ) {
				datasource.setMySQL5(
					name="commonspot-external",
					host="mysql",
					database="commonspot-external",
					username='root',
					password='password'
				);
			} else {
				break;
			}
		}

		datasourceMappings = datasource.getDatasources();
		// writeDump(var=datasourceMappings, expand=false);
	}

	catch ( any error ) {
		writeDump(var=error, expand=false, label='create datasource error.');
	}

	// NOTE: Add a new table for logging
	saveData = [
		'data TEXT',
		'username VARCHAR(50)'
	];
	// standardFields = [ 'created DATETIME NOT NULL', 'commonspotServerID VARCHAR(50)', 'commonspotServerName VARCHAR(50)', 'commonspotUserInfo VARCHAR(250)', 'pathTranslated VARCHAR(250)', 'queryString VARCHAR(50)', 'referer VARCHAR(50)', 'remoteAddress VARCHAR(50)', 'remoteHost VARCHAR(50)', 'requestMethod VARCHAR(50)', 'scriptName VARCHAR(50)', 'serverID VARCHAR(50)', 'serverName VARCHAR(50)', 'type VARCHAR(50)', 'url VARCHAR(250)', 'userAgent VARCHAR(250)', 'uuid VARCHAR(35) NOT NULL', 'PRIMARY KEY ( uuid )' ];

	logTesting = new com.log(
		name = 'testing',
		useTable = 1,
		useFile = 0,
		fields = saveData
	);

	entryData = {
		data='test',
		type='info',
		username='mike tester'
	};

	logTesting.update(entry=entryData);

	// logTesting.update(entry='some content here.');

	writeOutput('<h1>Index File Dumps!</h1>');

	writeDump(var=logTesting, expand=false, label='logTesting in index.cfm.');
	writeDump(var=variables, expand=false, label='Variables in index.cfm.');
	// writeDump(var=request, expand=false, label='request in index.cfm.');
	// writeDump(var=application, expand=false, label='application.');
	// writeDump(var=server, expand=false, label='server in index.cfm.');
</cfscript>
