/**
* @accessors true
* @author 'Gary L. Clark II (clarkgar)'
* @copyright 'Copyright 2020, Seton Hall University. All Rights Reserved.'
* @description 'Provides the functionality to interact with datasources.'
* @displayName 'SHU Datasource Functions'
* @hint 'Defines functions for interacting with CF datasources'
* @name 'dbs'
* @output true
*/

component {
	// Property Definitions
	/**
	* @default 'commonspot-external'
	* @displayName 'Datasource'
	* @hint 'Provides the initial datasource to create tables in.'
	* @type string
	*/
	property dsn;

	/**
	 * @displayName 'Initialization'
	* @description 'Intializes the component'
	* @hint 'Initializes the component'
	* @output true
	*/

	//! TODO: Create a function to ensure that the requested database is valid.

	package struct function init() {
		// NOTE: Let's just return the object here...
		return this;
	}

	/**
	* @displayName 'Create Table'
	* @description 'Creates a new table in the specified datasource.'
	* @hint 'Creates table.'
		* @output true
		*/

	package any function tableCreate(
		required string tableName,
		required string columns,
		string datasource=getDSN(),
		string type='permanent',
		boolean checkExisting=true
	) {
		// NOTE: Create a place holder structure to be returned.
		data = structNew();

		// NOTE: Remove the spaces from the table name
		arguments.tableName = removeSpaces(arguments.tableName);

		// NOTE: Check for existing tables?
		if ( arguments.checkExisting ) {
			checkExists = 'IF NOT EXISTS ';
		} else {
			checkExists = '';
		}

		// NOTE: Check to see if this is a temporary table
		if ( arguments.type neq 'permanent' ) {
			tableType = 'TEMPORARY ';
		} else {
			tableType = '';
		}

		// NOTE: Create a new query() to insert data.
		qryGet = new query();
		qryGet.setDatasource(arguments.datasource);
		qryGet.setName('createTable');

		qryGet.setSQL('
			CREATE ' & tableType & 'TABLE ' & checkExists & '`' & arguments.tableName & '`' & ' (' & arguments.columns & ');
		');
		// writeDump(var=qryGet, expand=false, label='qryGet from dbs.tableCreate()');

		// NOTE: Execute the query.
		qryExecute = qryGet.execute();

		data.result = qryExecute.getResult();
		data.prefix = qryExecute.getPrefix();
		// writeDump(var=qryExecute, expand=false, label='query from dbs.tableCreate()');
		// writeDump(var=arguments, expand=false, label='dbs.createTable() Arguments');
		// writeDump(var=data, expand=false, label='Data from dbs.tableCreate()');

		// NOTE: Clear out the query so we can run another one fresh.
		qryGet.clearParams();

		return data;
	}

	/**
	* @displayName 'Create Table Index'
	* @description 'Creates an index on the given column(s) for a given table.'
	* @hint 'Creates an index on a table.'
	* @output true
	*/

	package boolean function tableCreateIndex(
		required string tableName,
		required string columnList, // list of columns to create the index with.
		string datasource=getDSN()
	) {
		// NOTE: Create a place holder structure to be returned.
		data = structNew();

		// NOTE: Remove the spaces from the table name
		arguments.tableName = removeSpaces(arguments.tableName);

		// NOTE: Create a new query() to insert data.
		qryIndex = new query();
		qryIndex.setDatasource(arguments.datasource);
		qryIndex.setName('createIndex');

		qryIndex.setSQL('
		CREATE INDEX `index_' & arguments.tableName & '`
		ON `' & arguments.tableName & '` (' & arguments.columnList & ')
		');

		// NOTE: Execute the query.
		qryExecute = qryIndex.execute();

		data.result = qryExecute.getResult();
		data.prefix = qryExecute.getPrefix();
		// writeDump(var=arguments, expand=false, label='createTable Arguments');
		// writeDump(var=qryExecute, expand=false, label='qryIndex from table check function');
		// writeDump(var=data, expand=false, label='Data from table check function');

		return true;
	}

  /**
  * @displayName 'Add Table Data'
  * @description 'Adds data to a given table in the specified datasource.'
  * @hint 'Adds data to table.'
  * @output true
  */

	package struct function tableAdd(
		required string name,
		required string columns,
		required string values,
		string datasource=getDSN()
	) {
		// writeDump(var=arguments, expand=false, label='Arguments from dbs.tableAdd()');

		// NOTE: Create a place holder structure to be returned.
		var data = {};

		// NOTE: Remove the spaces from the table name
		arguments.name = removeSpaces(arguments.name);

		// NOTE: Create a new query() to insert data.
		var qryAdd = new query();
		qryAdd.setDatasource(arguments.datasource);
		qryAdd.setName('addTable');

		qryAdd.setSQL('
		INSERT INTO ' & arguments.name & ' (' & arguments.columns & ')
		VALUES (' & arguments.values & ');
		');

		writeDump(var=qryAdd, expand=false, label='qryAdd from dbs.tableAdd()');

		// NOTE: Execute the query.
		qryExecute = qryAdd.execute();
		writeDump(var=qryExecute, expand=false, label='qryExecute from dbs.tableAdd()');

		data.result = qryExecute.getResult();
		data.prefix = qryExecute.getPrefix();
		// writeDump(var=data, expand=false, label='Data from dbs.tableAdd()');

		// NOTE: Clear out the query so we can run another one fresh.
		qryAdd.clearParams();

		return data;
	}

  /**
  * @displayName 'Update Table Data'
  * @description 'Updates a given table in the specified datasource.'
  * @hint 'Updates table.'
  * @output true
  */

  package any function tableUpdate(
    required string tableName,
    required struct values,
    string datasource=getDSN()
  ) {
    // NOTE: Create a place holder structure to be returned.
    data = structNew();

    // NOTE: Remove the spaces from the table name
    arguments.tableName = removeSpaces(arguments.tableName);

    // NOTE: Create a new query() to insert data.
    qryUpdate = new query();
    qryUpdate.setDatasource(arguments.datasource);
    qryUpdate.setName('updateTable');

     qryUpdate.setSQL('
      UPDATE ' & arguments.tableName & ' SET
        col1 = 1,
        col2 = 2;
    ');

    // NOTE: Execute the query.
    // qryExecute = qryUpdate.execute();

    // data.result = qryExecute.getResult();
    // data.prefix = qryExecute.getPrefix();
    // writeDump(var=qryExecute(), expand=false, label='Data from function');
    writeDump(var=arguments, expand=false, label='createTable Arguments');
    writeDump(var=qryUpdate, expand=false, label='Data from function');

    // NOTE: Clear out the query so we can run another one fresh.
    qryUpdate.clearParams();

    return data;
  }

  /**
  * @displayName 'Read Table Data'
  * @description 'Reads a given table in the specified datasource.'
  * @hint 'Reads table.'
  * @output true
  */

  package struct function tableRead(
    required string tableName,
    string strFieldList = '*',
    string strWhere = '',
    string strOrderBy = '',
    numeric intMaxRows = 0,
    numeric intOffsetRows = 0,
    string datasource = getDSN()
  ) {
    // NOTE: Create a place holder structure to be returned.
    data = structNew();

    // NOTE: Remove the spaces from the table name
    arguments.tableName = removeSpaces(arguments.tableName);

    // NOTE: Check to see if we want to limit the results with a WHERE clause.
    if ( arguments.strWhere neq '' ) {
      this.whereClause = ' WHERE ' & arguments.strWhere;
    } else {
      this.whereClause = '';
    }

    // NOTE: Check to see if we want to order the results in a specific way.
    if ( arguments.strOrderBy neq '' ) {
      this.orderClause = ' ORDER BY ' & arguments.strOrderBy;
    } else {
      this.orderClause = '';
    }

    // NOTE: Check to see if we want to limit the results returned by a given number
    if ( arguments.intMaxRows neq 0 ) {
      this.limitClause = ' LIMIT ' & arguments.intMaxRows;
    } else {
      this.limitClause = '';
    }

    // NOTE: Check to see if we want to offset the results returned by a given number
    if ( arguments.intOffsetRows neq 0 ) {
      this.offsetClause = ' OFFSET ' & arguments.intOffsetRows;
    } else {
      this.offsetClause = '';
    }

    // NOTE: Create a new query() to read data.
    qryRead = new query();
    qryRead.setDatasource(arguments.datasource);
    qryRead.setName('readTable');

     qryRead.setSQL('
      SELECT ' & arguments.strFieldList & '
      FROM ' & arguments.tableName &
      this.whereClause &
      this.orderClause &
      this.limitClause &
      this.offsetClause & ';
    ');

    // NOTE: Execute the query.
    qryExecute = qryRead.execute();

    data.result = qryExecute.getResult();
    data.prefix = qryExecute.getPrefix();
    writeDump(var=qryExecute, expand=false, label='Data from function');
    writeDump(var=arguments, expand=false, label='createTable Arguments');
    writeDump(var=qryRead, expand=false, label='Data from function');

    // NOTE: Clear out the query so we can run another one fresh.
    qryRead.clearParams();

    return data;
  }

	/**
	 * @displayName 'Check for Table'
	* @description 'Checks for a given table in the specified datasource.'
	* @hint 'Checks table.'
	* @output true
	*/

	package boolean function tableCheck(
		required string tableName,
		string datasource=getDSN()
	) {
		// NOTE: Create a place holder structure to be returned.
		var data = structNew();

		try {
			// NOTE: Remove the spaces from the table name
			arguments.tableName = removeSpaces(arguments.tableName);

			// NOTE: Create a new query() to read data.
			qryCheck = new query();
			qryCheck.setDatasource(arguments.datasource);
			qryCheck.setName('checkTable');

			qryCheck.setSQL('
			SHOW TABLES
			LIKE ''' & arguments.tableName & ''';
			');

			// NOTE: Execute the query.
			qryExecute = qryCheck.execute();

			data.result = qryExecute.getResult();
			data.prefix = qryExecute.getPrefix();
			writeDump(var=arguments, expand=false, label='createTable Arguments');
			writeDump(var=qryExecute, expand=false, label='qryCheck from table check function');
			writeDump(var=data, expand=false, label='Data from table check function');

			// NOTE: Clear out the query so we can run another one fresh.
			qryCheck.clearParams();

			if ( data.prefix.recordCount eq 0 ) {
				return false;
			} else {
				return true;
			}
		}

		catch (any error) {
			writeDump(var=error, expand=false, label='Error from dbs.tableCheck()');
			rethrow;
		}

		finally {

		}
	}

  /**
  * @displayName 'Drop Table'
  * @description Deletes a given table in the specified datasource.'
  * @hint 'Drops a table.'
  * @output true
  */

  package boolean function tableDrop(
    required string tableName,
    string datasource=getDSN()
  ) {
    // NOTE: Create a place holder structure to be returned.
    data = structNew();

    // NOTE: Remove the spaces from the table name
    arguments.tableName = removeSpaces(arguments.tableName);

    // NOTE: Create a new query() to read data.
    qryDrop = new query();
    qryDrop.setDatasource(arguments.datasource);
    qryDrop.setName('dropTable');

     qryDrop.setSQL('
      DROP TABLE IF EXISTS
      ''' & arguments.tableName & ''';
    ');

    // NOTE: Execute the query.
    // qryExecute = qryDrop.execute();

    // data.result = qryExecute.getResult();
    // data.prefix = qryExecute.getPrefix();
    // writeDump(var=qryExecute, expand=false, label='qryDrop from table drop function');
    writeDump(var=qryDrop, expand=false, label='qryDrop from table drop function');
    writeDump(var=arguments, expand=false, label='createTable Arguments');
    writeDump(var=data, expand=false, label='Data from table drop function');

    // NOTE: Clear out the query so we can run another one fresh.
    qryDrop.clearParams();

    if ( data.prefix.recordCount eq 0 ) {
      return false;
    } else {
      return true;
    }

  }

  /**
  * @displayName 'Count Records'
  * @description 'Counts the records in a given table'
  * @hint 'Counts the records.'
  * @output true
  */

  package struct function countRecords(
    required string tableName,
    string datasource=getDSN()
  ) {
    // NOTE: Create a place holder structure to be returned.
    data = structNew();

    // NOTE: Remove the spaces from the table name
    arguments.tableName = removeSpaces(arguments.tableName);

    // NOTE: Create a new query() to read data.
    qryCount = new query();
    qryCount.setDatasource(arguments.datasource);
    qryCount.setName('countRecords');

     qryCount.setSQL('
      SELECT COUNT(DISTINCT uuid)
      FROM ' & arguments.tableName & ';
    ');

    // NOTE: Execute the query.
    qryExecute = qryCount.execute();

    data.result = qryExecute.getResult();
    data.prefix = qryExecute.getPrefix();
    // writeDump(var=qryExecute, expand=false, label='qryCount from table drop function');
    writeDump(var=qryCount, expand=false, label='qryCount from table drop function');
    writeDump(var=arguments, expand=false, label='createTable Arguments');
    writeDump(var=data, expand=false, label='Data from table drop function');

    // NOTE: Clear out the query so we can run another one fresh.
    qryCount.clearParams();

    return data;
  }

  /**
  * @displayName 'Remove Spaces'
  * @description 'Replaces spaces in a given string with hyphens ("-") and converts to lower case.'
  * @hint 'Removes spaces.'
  * @output true
  */

  private string function removeSpaces(
    required string text
  ) {
    return replaceNoCase(lcase(trim(arguments.text)),' ', '_', 'all');
  }

}
