<cfscript>
	writeOutput('<p>Attempting to create a database that we can use...</p>');
	writeLog(text='setupCFML.cfm init.', type='information', file='container-setup');

	try {
		// Login is always required. This example uses two lines of code.
		// adminObj = createObject("component","CFIDE.adminapi.administrator");
		adminObj = new CFIDE.adminapi.administrator();
		adminObj.login("password"); //CF Admin password
		writeDump(var=adminObj, expand=false);

		// Create a MySQL datasource
		// datasource = createObject("component", "CFIDE.adminapi.datasource");
		datasource = new CFIDE.adminapi.datasource();
		datasource.setMySQL5(
			name="commonspot-external",
			host="mysql",
			database="custom_logger",
			username='root',
			password='password'
		);
		writeDump(var=datasource.getDatasources(), expand=false);
		writeLog(text='setupCFML.cfm set the container up w/ a db.', type='information', file='container-setup');
	}

	catch (any error) {
		writeDump(var=error);
		writeLog(text='There was an error with setupCFML.cfm', type='error', file='container-setup');
		rethrow;
	}

	finally {
	}
</cfscript>
