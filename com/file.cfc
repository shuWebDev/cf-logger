/**
* @accessors true
* @author 'Gary L. Clark II (clarkgar)'
* @copyright 'Copyright 2016, Seton Hall University. All Rights Reserved.'
* @description 'Provides the functionality to manipulate the file system as it relates to log files.'
* @displayName 'SHU CommonSpot Logging Functions'
* @hint 'Defines functions for logging the interactions within CommonSpot'
* @name 'file'
* @output false
*/

component {
  // Property Definitions
  /**
  * @default '/cust/webroot/cslogs'
  * @displayName 'Base File Path'
  * @hint 'Provides the initial path where logs would be saved.'
  * @setter false
  * @type string
  */
  property filePathRoot;

  /**
  * @default 'json'
  * @displayName 'Default File Type'
  * @hint 'Provides the initial type where logs would be saved as. Valid types should be JSON, XML, CSV or TXT (as a last resort)'
  * @type string
  */
  property fileType;

  /**
  * @access 'package'
  * @displayName 'Initialization'
  * @description 'Intializes the component'
  * @hint 'Initializes the component'
  * @output false
  * @returnType any
  */

  function init() {

    return this;
  }

  /**
  * @access 'package'
  * @displayName 'Check For Log'
  * @description 'Checks for an existing log.'
  * @hint 'Checks existence of a log.'
  * @output false
  * @returnType boolean
  */

  function check( required string fileName, uuid id ) {
    return fileExists(arguments.fileName);
  }

  /**
  * @access 'package'
  * @displayName 'Create Log'
  * @description 'Creates a new log.'
  * @hint 'Creates log.'
  * @output false
  * @returnType struct
  */

  function create( required string fileName ) {
    var this = structNew();

    try {
        this.file = fileOpen(arguments.fileName, 'write', 'utf-8', false);
        this.uuid = createUUID();

        // Write default info to the file
        fileWrite(this.file,'{"id":"' & this.uuid & '", "name":"' & arguments.fileName & '", "entries":[{"created":"' & dateTimeFormat(now(), 'yyyy-mm-dd HH:nn:ss')& '", "type":"info", "id":"' & createUUID() & '", "data":{"message":"Log file created."}}]}');
        fileClose(this.file); // close the file.
    }

    catch (any e) {
      // writeDump(var=this, expand=false, label='"this" at an error.');
      // writeDump(var=e, expand=false, label='Error in log.create()');
      this.error = e;
    }

    // NOTE: Always do this...
    finally {
      // writeDump(var=this, expand=false, label='create() finally');
      return this;
    }
  }

  /**
  * @access 'package'
  * @displayName 'Delete Log'
  * @description 'Deletes an existing log.'
  * @hint 'Deletes log.'
  * @output true
  * @returnType any
  */

  function delete( required string fileName, uuid id ) {
    return 'Not yet implemented.';
  }

  /**
  * @access 'package'
  * @displayName 'Set File Path'
  * @description 'Sets a log file path based on today''s date.'
  * @hint 'Sets log file path.'
  * @output false
  * @returnType any
  */

  function setFilePath( required string fileName, date fileDate, string fileType=getFileType() ) {
    var data = structNew();

    // NOTE: Check to see if a date was passed in
    if ( isDefined('fileDate') ) {
      data.fileDate = dateFormat(fileDate, 'yyyymmdd');
    } else {
      data.fileDate = dateFormat(now(), 'yyyymmdd');
    }

    // NOTE: Check to see if there's a file type
    if ( !isDefined('fileType') ) {
      fileExtension = getFileType();
    } else {
      fileExtension = fileType;
    }

    data.fileName = replaceNoCase(lcase(trim(fileName)),' ', '-', 'all') & '-' & data.fileDate & '.' & fileExtension;
    data.fullPath = getFilePathRoot() & '/' & data.fileName;

    // writeDump(var=data, expand=false, label='setFilePath() data');
    return data;
  }

  /**
  * @access 'package'
  * @displayName 'Create Directory'
  * @description 'Creates a directory on the file system if it doesn't already exist.'
  * @hint 'Creates a directory.'
  * @output false
  * @returnType boolean
  */

  function createDirectory( required string path ) {
    // NOTE Try to create the directory.
    try {
      this.exists = directoryExists(arguments.path);
      directoryCreate(arguments.path);

      if ( this.exists ) {
        throw(type='directory.exists', message='Directory already exists.', detail='Message from path check: ' & this.exists);
      }

      return true;
    }

    catch ('directory.exists' e) {
      writeDump(var=e, expand=false, label='Directory Exists Error');
      return false;
    }

    catch (any e) {
      writeDump(var=e, expand=false, label='Directory Creation General Error');
      return false;
    }

    finally {
      // writeDump(var=arguments, expand=false, label='arguments @ directoryCreate() finally');
      // writeDump(var=this, expand=false, label='this @ directoryCreate() finally');
    }

  }
}
