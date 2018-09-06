// table-list.js
appCSLogs.controller('TableController', ['$scope', '$http', '$log', function($scope, $http, $routeParams) {
	$scope.pageMaxItems = 13;
	$scope.pageCurrent = 1;

	// $scope.tableCurrent = 'DISPLAYNAME';

	// NOTE: Get the data for the selected log.
	$http.get('/webadmin/com/logs/log.cfc?method=readTable&strOrderBy=created%20desc&path=' + $scope.$routeParams.log + '&intMaxRows=' + $scope.pageMaxItems + '&intPage=' + $scope.pageCurrent).then(function(response, status, headers, config) {
		$scope.entries =  angular.fromJson(response.data.DATA);

		// NOTE: Get the total number of records in the table.
		$scope.getDataCount($scope.$routeParams.log);
		// console.log(response);
	});

	// console.log($scope);

	// NOTE: Function to show usage.
	$scope.showUsageView = function () {
		$scope.tableCurrent = null;
	}

	$scope.getDataCount = function(tableName) {
		$http.get('/webadmin/com/logs/table.cfc?method=countRecords&tableName=' + tableName).then(function(response, status, headers, config) {
			$scope.entryCount = response.data.DATA[0][0];
			// console.log(response);
			// console.log($scope);
		});
	}

	$scope.getPagedData = function(page, limit) {
		// console.log('Scope Page: ' + $scope.pageCurrent + ' Scope Limit: ' + $scope.pageMaxItems);
		// console.log('Page: ' + page + ' Limit: ' + limit);
		// console.log($scope);

		$http.get('/webadmin/com/logs/log.cfc?method=readTable&strOrderBy=created%20desc&path=' + $scope.$routeParams.log + '&intMaxRows=' + $scope.pageMaxItems + '&intPage=' + $scope.pageCurrent).then(function(response, status, headers, config) {
			$scope.entries =  angular.fromJson(response.data.DATA);
			// console.log(response);
			// console.log($scope);
		});
	}
}]);
