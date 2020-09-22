/**
* @accessors true
* @author 'Gary L. Clark II (clarkgar)'
* @copyright 'Copyright 2016, Seton Hall University. All Rights Reserved.'
* @description 'Provides the functionality write log information to a database table.'
* @displayName 'SHU CommonSpot Logging Database Functions'
* @hint 'Defines functions for logging the interactions within CommonSpot to a table'
* @name 'table'
* @output true
*/

component {
	// Property Definitions
	/**
	* @default 'commonspot-external'
	* @displayName 'Datasource'
	* @hint 'Provides the initial ColdFusion data source to create tables in.'
	* @type string
	*/
	property dsn;

	// Variable Definitions

	// NOTE: Create an object so we can access the db component.
	variables.dbs = new dbs();

	/**
	* @displayName 'Initialization'
	* @description 'Intializes the component.'
	* @hint 'Initializes component.'
	* @output false
	*/

	package struct function init() {
		return this;
	}

	/**
	* @displayName 'Create Log Table'
	* @description 'Creates a new table for a log.'
	* @hint 'Creates table.'
	* @output true
	*/

	package any function create( //boolean
		required string name hint='The name of the table to be created.',
		required array fields hint='The columns of data to be saved.'
	) {
		writeDump(var=arguments, expand=false, label='table.create() arguments');

		try {
			variables.dbs.tableCreate(tableName = arguments.name, columns = arrayToList(arguments.fields));
			// variables.dbs.tableCreateIndex(tableName = arguments.name, columnList = 'created');
			return this;
		}

		catch (any error) {
			writeDump(var=this, expand=false, label='"data" at table.create().');
			writeDump(var=error, expand=false, label='Error in table.create()');
			rethrow;
			return false;
		}

		// NOTE: Always do this...
		finally {}
	}

  /**
  * @displayName 'Add Log Data to DB Table'
  * @description 'Adds log data to a database table.'
  * @hint 'Adds log data to db table.'
  * @output true
  */

	package any function addData(
		required string name,
		required struct data
	) {
		var columns = '';
		var values = '';
		var entryAdded = {};

		data.each(
			function(key, value) {
				values.listAppend(value);
				columns.listAppend(key);
			}
		);
		writeDump(var=columns, expand=false, label='column list table.add()');
		writeDump(var=values, expand=false, label='values list table.add()');

		var entryAdded = variables.dbs.tableAdd(
			name = arguments.name,
			columns = columns,
			values = values
		);

		return entryAdded;
	}

  /**
  * @displayName 'Read Table Data'
  * @description 'Reads log records from a database table.'
  * @hint 'Reads table.'
  * @output true
  */

  package any function read(
	required string tableName,
	string strFieldList = '',
	string strWhere = '',
	string strOrderBy = ' created DESC ',
	numeric intMaxRows = 0,
	numeric intPage = 1
  ) {
	var data = structNew();
	var offset = (intPage - 1) * intMaxRows;

	data = variables.dbs.tableRead(
	  tableName = arguments.tableName,
	  strFieldList = arguments.strFieldList,
	  strOrderBy = arguments.strOrderBy,
	  strWhere = arguments.strWhere,
	  intMaxrows = arguments.intMaxRows,
	  intOffsetRows = offset
	);

	writeDump(var=data, expand=false, label='logs.table.read()');
	return data;
  }

	/**
	* @displayName 'Check for Table'
	* @description 'Checks a database for a given table.'
	* @hint 'Checks table.'
	* @output false
	*/

	private boolean function check(
		required string name hint='The name of the table to check.'
	) {
		return variables.dbs.tableCheck(arguments.name);
	}

  /**
  * @displayName 'Count Table Records'
  * @description 'Counts the number of log records in a log table.'
  * @hint 'Counts log records.'
  * @output true
  */

  package query function countRecords( required string tableName ) {
	var data = structNew();

	// NOTE: Get the record count by calling variables.db.countRecords
	data = variables.dbs.countRecords(tableName = arguments.tableName);
	writeDump(var=data);

	// NOTE: Convert the result to a number.
	count = data.result;

	// NOTE: Return the value to the caller.
	return count;
  }

  /**
  * @displayName 'List Log Tables'
  * @description 'Lists the log tables in the database.'
  * @hint 'List tables.'
  * @output true
  */

  package array function list() {
	// NOTE: Create a place holder structure to be returned.
	var data = {};
	var arrayTableList = [];

	// NOTE: Create a new query() to read data.
	qryList = new query();
	qryList.setDatasource(getDSN());
	qryList.setName('listTables');

	 qryList.setSQL('
	  SHOW TABLES
	  LIKE ''log_%'';
	');

	// NOTE: Execute the query.
	qryExecute = qryList.execute();

	data.result = qryExecute.getResult();
	data.prefix = qryExecute.getPrefix();
	writeDump(var=qryExecute, expand=false, label='qryList from table check function');
	writeDump(var=data, expand=false, label='Data from table check function');

	// NOTE: Clear out the query so we can run another one fresh.
	qryList.clearParams();

	// NOTE: Check to see if there are tables to return
	if ( data.prefix.recordCount eq 0 ) {
	  return [];
	} else {
	  for ( entry in data.result ) {
		tmp = {};
		tmp.displayName = uCase(replace(replace(entry['TABLES_IN_CUST_SHU_DB (LOG_%)'],'log_',''), '_', ' ', 'all'));
		tmp.tableName = replace(entry['TABLES_IN_CUST_SHU_DB (LOG_%)'],'log_','');
		arrayAppend(arrayTableList, tmp);
	  }

	  // writeDump(var=arrayTableList, expand=false);

	  return arrayTableList;
	}
  }

}
