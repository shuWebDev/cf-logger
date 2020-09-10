<cfscript>
	// Login is always required. This example uses two lines of code.
	// adminObj = createObject("component","CFIDE.adminapi.administrator");
	adminObj = new CFIDE.adminapi.administrator();
	adminObj.login("password"); //CF Admin password

	// Create a MySQL datasource
	// datasource = createObject("component", "CFIDE.adminapi.datasource");
	datasource = new CFIDE.adminapi.datasource();
	datasource.setMySQL5(
		name="commonspot-external",
		host="localhost",
		database="custom_logger",
		username='mysql',
		password='password'
	);
</cfscript>
