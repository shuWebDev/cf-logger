// entry-list.js
appCSLogs.controller('EntryListController', function($scope, $mdDialog, $mdMedia, $log) {
	var tmpData = angular.fromJson($scope.entry[1]);
	var tabs = [];

	$scope.entryCreated = Date.parse($scope.entry[0]);
	$scope.entryType = $scope.entry[6];
	$scope.entryServerID = $scope.entry[5];
	$scope.entryUUID = $scope.entry[7];
	$scope.entryMessage = tmpData.MESSAGE;
	$scope.exceptionType = '';

	// NOTE: Check to see what type of entry we're looking at.
	if ( $scope.entryType == 'error' ) {
		$scope.entryClass = 'md-accent';
	} else if ($scope.entryType == 'warning') {
		$scope.entryClass = 'md-warn';
	} else {
		$scope.entryClass = 'md-hue-1';
	}

	// NOTE: Check to see if there is an exception message.
	if ( tmpData.EXCEPTIONTYPE ) {
		$scope.exceptionType = tmpData.EXCEPTIONTYPE + ' Exception: ';
	}

	// NOTE: Check for exception data
	if ( tmpData.TAGCONTEXT ) {
		tabs.push({title:'Tag Context', data:tmpData.TAGCONTEXT})
	}

	// NOTE: Check for exception data
	if ( tmpData.DATAVALUES ) {
		tabs.push({title:'Data Values', data:tmpData.DATAVALUES})
	}

	// NOTE: Check for exception data
	if ( tmpData.CGI ) {
		tabs.push({title:'CGI Variables', data:tmpData.CGI})
	}

	// NOTE: Check for exception data
	if ( tmpData.USER ) {
		tabs.push({title:'User Info', data:tmpData.USER})
	}

	// NOTE: Check for exception data
	if ( tmpData.BROWSER ) {
		tabs.push({title:'Browser', data:tmpData.BROWSER})
	}

	$scope.tabs = tabs;

	$scope.showEntry = function(ev) {
		// console.log($scope);

		$mdDialog.show({
			clickOutsideToClose:true,
			controller:DialogController,
			scope: $scope,
			preserveScope: true,  // do not forget this if use parent scope
			targetEvent: ev,
			clickOutsideToClose:true,
			ariaLabel:'Log Entry Detail',
			templateUrl: 'views/entry-detail-dialog.tmpl.html'
		});
	};

});
