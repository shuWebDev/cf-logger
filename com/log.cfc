/**
* @accessors true
* @rest true
* @restPath 'logs'
* @author 'Gary L. Clark II (clarkgar)'
* @copyright 'Copyright 2016, Seton Hall University. All Rights Reserved.'
* @description 'Provides the functionality to log anything.'
* @displayName 'SHU CommonSpot Logging Functions'
* @hint 'Defines functions for logging the interactions within CommonSpot'
* @name 'log'
* @output false
*/

component {
	// Property Definitions
	/**
	* @displayName 'File Name'
	* @hint 'The file name where log entries will be saved in.'
	* @required true
	* @type string
	*/
	property fileName;

	/**
	* @default 'json'
	* @displayName 'Default File Type'
	* @hint 'Provides the initial type where logs would be saved as. Valid types should be JSON, XML, CSV or TXT (as a last resort)'
	* @type string
	*/
	property fileType;

	/**
	* @access 'public'
	* @displayName 'Initialization'
	* @description 'Initializes the component'
	* @hint 'Initializes the component'
	* @output false
	* @returnType log
	*/

	function init(
		required string fileName,
		string fileType = ''
	) {

		// Variable Definitions
		// NOTE: Create an object so we can access the "file" component.
		variables.logFile = createObject("component", 'preview.webadmin.com.logs.file');

		// NOTE: Create an object so we can access the "db" component.
		variables.logTable = createObject("component", 'preview.webadmin.com.logs.table');

		// NOTE: Create an object so we can access the "extra" component.
		variables.logExtra = createObject("component", 'preview.webadmin.com.logs.extra');

		// NOTE: Set the file name
		setFileName(arguments.fileName);

		// NOTE: Set the file type if it's passed in.
		if ( len(arguments.fileType) ) {
		  setFileType(arguments.fileType);
		} else {
		  setFileType(variables.logFile.getFileType());
		}

		return this;
	}

	/**
	* @access 'public'
	* @displayName 'Read Log File'
	* @description 'Reads a log file from disk.'
	* @hint 'Reads log file.'
	* @output false
	* @returnType struct
	*/

	function readFile( required string path, uuid id ) {
		var data = structNew();
		data.content = fileRead(path, 'utf-8');
		data.length = len(data.content);
		// writeDump(var=data, expand=false, label='read()');

		return data;
	}

	/**
	* @access 'remote'
	* @displayName 'Read Log Table'
	* @description 'Reads a log from a database table.'
	* @hint 'Reads log table.'
	* @output false
	* @returnType any
	* @returnFormat plain
	*/

	function readTable(
		string path = getFileName(),
		string strFieldList = '*',
		string strWhereClause = '',
		string strOrderBy = '',
		numeric intMaxRows = 0,
		numeric intPage = 1,
		string callback = ''
	) {
		var response = {};
		writeDump(var=arguments, expand=false, label='logs.log.readTable() arguments');

		if (!isDefined("variables.table")) {
			// NOTE: Create an object so we can access the "table" component.
			variables.logTable = createObject("component", 'preview.webadmin.com.logs.table');
		}

		response = variables.logTable.read(arguments.path, arguments.strFieldList, arguments.strWhereClause, arguments.strOrderBy, arguments.intMaxRows, arguments.intPage);
		writeDump(var=response, expand=false, label='logs.log.readTable()');

		pc = getPageContext().getResponse();

		// NOTE: Return just the data...
		if ( callback neq '' ) {
			pc.setContentType("text/javascript");
			return callback & '( ' & serializeJSON(response.result) & ' );';
		} else {
			pc.setContentType("application/json");
			return serializeJSON(response.result);
		}
	}

	/**
	* @access 'public'
	* @displayName 'Read Log as Raw JSON'
	* @description 'Reads a log and returns the contents as as a raw JSON string.'
	* @hint 'Reads log.'
	* @output false
	* @returnType string
	*/

	function readJSON( required string path, uuid id ) {
		var data = '';
		data = fileRead(path, 'utf-8');

		return data;
	}

	/**
	* @access 'public'
	* @displayName 'Update Log'
	* @description 'Updates an existing log.'
	* @hint 'Updates log.'
	* @output false
	* @returnType any
	*/

	function update(
		required struct entry,
		string fileName=getFileName(),
		string entryType = 'info',
		string fileType = getFileType(),
		string serverIP = evaluate('request.cp.serverCache.#request.cp.serverID#.ip'),
		string serverName = evaluate('request.cp.serverCache.#request.cp.serverID#.name'),
		string serverID = request.cp.serverID
	) {
		// NOTE: Set default values;
		var data = structNew();
		data.orig.fileName = arguments.fileName;
		data.orig.fileType = arguments.fileType;
		data.entryType = arguments.entryType;
		data.entry = arguments.entry;
		data.entry.browser = variables.logExtra.getBrowserInfo();
		data.entry.cgi = variables.logExtra.getCGIInfo();
		data.entry.user = variables.logExtra.getUserData();
		data.serverIP = arguments.serverIP;
		data.serverName = arguments.serverName;
		data.serverID = arguments.serverID;
		data.uuid = createUUID();
		data.created = dateTimeFormat(now(), 'yyyy-mm-dd HH:nn:ss.l');

		try {
			// data.filePathInfo = variables.logFile.setFilePath(fileName=arguments.fileName, date=now());

			// // NOTE: Check to see if a file with file name already exists
			// data.checkFile = variables.logFile.check(data.filePathInfo.fullPath);

			// // NOTE: If the file doesn't exist, then create a new one and return the UUID, file name, file path and creation time as a structure
			// if ( !data.checkFile ) {
			//   data.newDirectory = variables.logFile.createDirectory(variables.logFile.getFilePathRoot());
			//   data.newFile = variables.logFile.create(data.filePathInfo.fullPath);
			// // writeDump(var=data.newFile, expand=false, label='New Log File from update()');
			// }



			// // ===============
			// // FIXME: Should this be part of the file component as update()?
			// // ===============

			// // NOTE: Open the existing file and get it's file size.
			// data.file = fileOpen(data.filePathInfo.fullPath, 'readwrite', 'utf-8', true);
			// // writeDump(var=data, expand=false, label='update() after file open');

			// // NOTE: Find the end of the file and back up two(2) characters to place data in front of "]}"
			// if ( data.file.size ) {
			//   data.writeStartPos = data.file.size - 2;
			//   fileSeek(data.file, data.writeStartPos);

			// // NOTE: Write data to the file
			//   data.entryFull = ',{"created":"' & data.created & '", "type":"' & data.entryType & '", "id":"' & data.uuid & '", "serverID":"' & data.serverID & '", "serverIP":"' & data.serverIP & '", "serverName":"' & data.serverName & '", "data":' & serializeJSON(data.entry) & '}]}';

			//   fileWrite(data.file, data.entryFull);
			// }

			// // writeDump(var=data, expand=false, label='update() complete');
			// fileClose(data.file);

			// // ==========
			// // FIXME: end
			// // ==========


			// NOTE: Check to see if a db table for the log exists
			data.checkTable = variables.logTable.check( tableName=arguments.fileName );
			// writeDump(var=data.checkTable, expand=false, label='Check table from update()');

			// NOTE: If the file doesn't exist, then create a new one and return the UUID, file name, file path and creation time as a structure
			if ( !data.checkTable ) {
				data.newTable = variables.logTable.create(arguments.fileName);
				// writeDump(var=data.newTable, expand=false, label='New table from update()');
			}

			// NOTE: Generate a list of values to insert into the db.
			data.addTableDataList = "'" & data.created & "', '" & serializeJSON(data.entry) & "', '', '" & data.serverID & "', '" & data.serverIP & "', '" & data.serverName & "', '" & data.entryType & "', '" & data.uuid & "'";

			// NOTE: Update the db table with the log info.
			data.addTableData = variables.logTable.addData(tableName = arguments.fileName, valuesList = data.addTableDataList);
		}

		catch (any e) {
			writeDump(var=data, expand=false, label='"data" at an log.update().');
			writeDump(var=e, expand=false, label='Error in log.update()');
		}

		// NOTE: Always do this...
		finally {
			// writeDump(var=data, expand=false, label='update() finally');
			return data;
		}
	} // end update()

	/**
	* @access 'remote'
	* @displayName 'Export Log'
	* @description 'Exports for an existing log.'
	* @hint 'Exports log.'
	* @output false
	* @returnType string
	*/

	function export( required string fileName, uuid id, string format='json' ) {
		return 'Not yet implemented';
	}
}
