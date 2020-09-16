<cfscript>
	// NOTE:
	//	For local development testing, check to make sure you have the database mapped.
	//	If it isn't mapped, map it...
	try {
		adminstrator = new CFIDE.adminapi.administrator();
		adminstrator.login("password"); // local CF Admin password
		writeDump(var=adminstrator, expand=false);
		datasource = new CFIDE.adminapi.datasource();
		writeDump(var=datasource, expand=false);
		datasourceMappings = datasource.getDatasources();

		for ( mapping in datasourceMappings ) {
			writeOutput('<p>Mapping: ' & mapping & '</p>');
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
		'type VARCHAR(50)',
		'username VARCHAR(50)'
	];

	logTesting = new com.log(
		name = 'testing',
		useTable = 1,
		useFile = 0,
		tableColumns = saveData
	);

	// logTesting.update(entry='some content here.');

	writeOutput('<h1>Index File Dumps!</h1>');

	writeDump(var=logTesting, expand=false, label='logTesting in index.cfm.');
	writeDump(var=variables, expand=false, label='Variables in index.cfm.');
	writeDump(var=request, expand=false, label='request in index.cfm.');
	// writeDump(var=application, expand=false, label='application.');
	writeDump(var=server, expand=false, label='server in index.cfm.');
</cfscript>
