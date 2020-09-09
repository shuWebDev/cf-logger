<cfscript>
	saveData = ['uuid', 'timeStamp', 'data', 'username', 'page'];
	logTesting = new com.log(
		name = 'testing',
		createTable = 1,
		createFile = 0,
		tableColumns = saveData
	);

	// logTesting.

	writeDump(var=logTesting, expand=false, label='logTesting.');
	writeDump(var=variables, expand=false, label='Variables.');
	writeDump(var=request, expand=false, label='request.');
	// writeDump(var=application, expand=false, label='application.');
	writeDump(var=server, expand=false, label='server.');
</cfscript>
