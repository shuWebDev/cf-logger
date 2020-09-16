/**
* @accessors true
* @rest true
* @restPath 'logs'
* @author 'Gary L. Clark II (clarkgar)'
* @copyright 'Copyright 2020, Seton Hall University. All Rights Reserved.'
* @description 'Provides the functionality to log anything.'
* @displayName 'SHU CommonSpot Logging Functions'
* @hint 'Defines functions for logging "the stuff".'
* @name 'log'
* @output true
*/

component {
	// Property Definitions
	/**
	* @displayName 'Name of log'
	* @hint 'The name where log entries will be saved in.'
	* @required true
	* @type string
	*/
	property name;

	/**
	* @displayName 'File path of log'
	* @hint 'The path where log entries will be saved in.'
	* @required false
	* @type string
	*/
	property filePath;

	/**
	* @displayName 'Name of table'
	* @hint 'The table name where log entries will be saved in.'
	* @required false
	* @type string
	*/
	property tableName;

	/**
	* @displayName 'Initialization'
	* @description 'Initializes the component'
	* @hint 'Initializes the component'
	* @output true
	*/

	// NOTE: Create an object so we can access the "extra" component.
	variables['extra'] = new extra();
	variables['table'] = new table();

	public struct function init(
		required string name hint='The name of the file to log to.',
		boolean useTable=1 hint='Create a table for this log.',
		boolean useFile=0 hint='Create a JSON file for this log.',
		array fields=[] hint='Columns for the table that gets created. We''ll also include browser & CGI info.'
	) {

		var standardFields = [
			'created DATETIME NOT NULL',
			'serverID VARCHAR(50)',
			'serverIP VARCHAR(50)',
			'serverName VARCHAR(50)',
			'uuid VARCHAR(35) NOT NULL',
			'PRIMARY KEY ( uuid )'
		];

		// Variable Definitions
		// NOTE: Set the name to be used for the file and table.
		setName('log_' & arguments.name);
		// setTableName(arguments.name);

		// NOTE: If we want to create a file, then...
		if ( arguments.useFile ) {
			this['useFile'] = arguments.useFile; // temp for debugging

			// NOTE: Create an object so we can access the "file" component.
			this['file'] = new file();

			// TODO: Check to see if the file exists. If it does, make note of it.
			// If it doesn't, create it.

			// NOTE: Set the file path for the log
			setFilePath(arguments.name & '.json');
			this['filePath'] = getFilePath();

			// fileCreate();
		}

		// NOTE: Let's create a table
		if ( arguments.useTable ) {
			try {
				if ( arguments.fields.isEmpty()) {
					arguments.fields = [
						'data TEXT'
					];
				}

				// NOTE: Append the standard columns to the table.
				arrayAppend(arguments.fields, standardFields, true);

				var this['useTable'] = arguments.useTable; // for debugging
				var this['fields'] = arguments.fields; // for debugging

				// NOTE: Check to see if the table exists. If not, create it.
				this['createLogTable'] = table.create(name=getName(), fields=arguments.fields);

				// writeDump(var=this.createLogTable, expand=false, label='log.init() createLogTable');
			}

			catch ( any error ) {
				// writeDump(var=error, expand=true, label='log.init - error');
				this['errorHappened'] = error;
				rethrow;
			}
		}

		return this;
	}

	/**
	* @access 'remote'
	* @displayName 'Read Log Table'
	* @description 'Reads a log from a database table.'
	* @hint 'Reads log table.'
	* @output false
	* @returnType any
	*/

	function tableRead(
		string path = getname(),
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

		// pc = getPageContext().getResponse();

		// NOTE: Return just the data...
		if ( callback neq '' ) {
			// pc.setContentType("text/javascript");
			// return callback & '( ' & serializeJSON(response.result) & ' );';
			return callback & '( ' & response.result & ' );';
		} else {
			// pc.setContentType("application/json");
			return response.result;
		}
	}

	/**
	* @displayName 'Create Log File'
	* @description 'Creates a log file from disk.'
	* @hint 'Creates log file.'
	* @output false
	*/

	package struct function fileCreate() {
		var data = {};

		data.content = fileCreate(path, 'utf-8');
		data.length = len(data.content);
		// writeDump(var=data, expand=false, label='Create()');

		return data;
	}

	/**
	* @displayName 'Read Log File'
	* @description 'Reads a log file from disk.'
	* @hint 'Reads log file.'
	* @output false
	*/

	public struct function fileRead(
		required string path hint='The path of the file that should be read'
	) {
		var data = {};

		data.content = fileRead(path, 'utf-8');
		data.length = len(data.content);
		// writeDump(var=data, expand=false, label='read()');

		return data;
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

	public function update(
		required struct entry,
		string name=getname(),
		string entryType = 'info',
		string fileType = getFileType(),
		string serverIP = evaluate('request.cp.serverCache.#request.cp.serverID#.ip'),
		string serverName = evaluate('request.cp.serverCache.#request.cp.serverID#.name'),
		string serverID = request.cp.serverID
	) {
		// NOTE: Set default values;
		var data = structNew();
		data.orig.name = arguments.name;
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
			// data.filePathInfo = variables.logFile.setFilePath(name=arguments.name, date=now());

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
			data.checkTable = variables.logTable.check( tableName=arguments.name );
			// writeDump(var=data.checkTable, expand=false, label='Check table from update()');

			// NOTE: If the file doesn't exist, then create a new one and return the UUID, file name, file path and creation time as a structure
			if ( !data.checkTable ) {
				data.newTable = variables.logTable.create(arguments.name);
				// writeDump(var=data.newTable, expand=false, label='New table from update()');
			}

			// NOTE: Generate a list of values to insert into the db.
			data.addTableDataList = "'" & data.created & "', '" & serializeJSON(data.entry) & "', '', '" & data.serverID & "', '" & data.serverIP & "', '" & data.serverName & "', '" & data.entryType & "', '" & data.uuid & "'";

			// NOTE: Update the db table with the log info.
			data.addTableData = variables.logTable.addData(tableName = arguments.name, valuesList = data.addTableDataList);
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

	function export( required string name, uuid id, string format='json' ) {
		return 'Not yet implemented';
	}
}
