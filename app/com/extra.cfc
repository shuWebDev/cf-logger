/**
* @accessors true
* @author 'Gary L. Clark II (clarkgar)'
* @copyright 'Copyright 2016, Seton Hall University. All Rights Reserved.'
* @description 'Provides the "extra" information used during logging.'
* @displayName 'SHU CommonSpot Logging Extras'
* @hint 'Defines functions for logging the interactions within CommonSpot'
* @name 'extra'
* @output true
*/

component {

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
	* @displayName 'Get Browser Info'
	* @description 'Gets the browser information from the request scope.'
	* @hint 'Gets #request.browser#'
	* @output false
	* @returnType struct
	*/

	function getBrowserInfo() {
		return request.browser;
	}

	/**
	* @access 'package'
	* @displayName 'Get CGI Info'
	* @description 'Gets the information from the CGI scope.'
	* @hint 'Gets #CGI#'
	* @output false
	* @returnType struct
	*/

	function getCGIInfo() {
		// NOTE: Add CGI variable info to the entry
		cgiVars = structNew();

		// NOTE: Check to see if the CGI variables exist.
		if ( isStruct(CGI) ) {
			cgiVars.cfTemplatePath = cgi.cf_template_path;
			cgiVars.https = cgi.https;
			cgiVars.host = cgi.http_host;
			cgiVars.referer = cgi.http_referer;
			cgiVars.url = cgi.http_url;
			cgiVars.userAgent = cgi.http_user_agent;
			cgiVars.localAddress = cgi.local_addr;
			cgiVars.pathInfo = cgi.path_info;
			cgiVars.pathTranslated = cgi.path_translated;
			cgiVars.queryString = cgi.query_string;
			cgiVars.remoteAddress = cgi.remote_addr;
			cgiVars.remoteHost = cgi.remote_host;
			cgiVars.remoteUser = cgi.remote_user;
			cgiVars.requestMethod = cgi.request_method;
			cgiVars.scriptName = cgi.script_name;
			cgiVars.serverName = cgi.server_name;
			cgiVars.serverPort = cgi.server_port;
			cgiVars.serverProtocol = cgi.server_protocol;
			cgiVars.serverSoftware = cgi.server_software;
			cgiVars.webserverAPI = cgi.web_server_api;
		}

		return cgiVars;
	}

	/**
	* @access 'package'
	* @displayName 'Get User Data'
	* @description 'Gets specific user data from the request scope.'
	* @hint 'Gets #request.user# data'
	* @output false
	* @returnType struct
	*/

	function getUserData() {
		// NOTE: Add User info to the entry
		userData = structNew();
		userData.id = request.user.id;
		userData.emailAddress = request.user.emailAddress;
		userData.firstName = request.user.firstName;
		userData.lastName = request.user.lastName;
		userData.lastLogin = request.user.lastLogin;
		userData.lastName = request.user.lastName;
		userData.loginTime = request.user.loginTime;
		userData.middleName = request.user.middle;
		userData.fullName = request.user.name;
		userData.previousLogin = request.user.previousLogin;
		userData.userID = request.user.userID;
		userData.voicePhone = request.user.voicePhone;

		return userData;
	}

}
