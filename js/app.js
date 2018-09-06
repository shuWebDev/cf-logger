var appCSLogs = angular.module('logViewer', ['ngMaterial', 'ngRoute', 'md.data.table']);

appCSLogs.config(['$mdThemingProvider', '$routeProvider', '$locationProvider', function($mdThemingProvider, $routeProvider, $locationProvider) {
	$mdThemingProvider.theme('default')
		.primaryPalette('blue-grey',{
			'hue-1':"200"
		})
		.accentPalette('red');

	$routeProvider
		.when('/component-log', {
			templateUrl: 'views/log-cfc.tmpl.html'
		})
		.when('/component-file', {
			templateUrl: 'views/file-cfc.tmpl.html'
		})
		.when('/component-extra', {
			templateUrl: 'views/extra-cfc.tmpl.html'
		})
		.when('/component-dbs', {
			templateUrl: 'views/dbs-cfc.tmpl.html'
		})
		.when('/component-table', {
			templateUrl: 'views/table-cfc.tmpl.html'
		})
		.when('/clog/:log', {
			templateUrl: 'views/log-view.tmpl.html',
			controller: 'TableController'
		})
		.when('/usage', {
			templateUrl: 'views/usage.tmpl.html'
		})
		.otherwise({
			redirectTo: '/usage'
		});

	  $locationProvider.html5Mode({
	  	enabled: false
	  });
}]);

appCSLogs.controller('MainController', function($http, $scope, $route, $routeParams, $location) {
	$scope.$route = $route;
	$scope.$routeParams = $routeParams;
	$scope.tableList = [];

	// NOTE: Get the list of logs from the db.
	$http.get('/webadmin/com/logs/table.cfc?method=list&returnFormat=json').then(function(response, status, headers, config) {
		$scope.tableCount =  response.data.length;
		$scope.tableList = response.data;
	});

	// NOTE: Make sure that all of the code blocks are colorized.
	$scope.$on('$includeContentLoaded', function (event, url) {
		// console.log(event);
		// console.log(url);
		Prism.highlightAll();
	});

	$scope.$on(
		"$routeChangeSuccess",
		function handleRouteChangeEvent( event ) {
			// console.log($location);
			// console.log($route);
			// console.log($routeParams);

			// NOTE: Change the page title based on the current route.
			switch ( $location.path() ) {
				case "/component-log":
					$scope.currentNavItem = 'cfc-log';
					$scope.currentPageTitle = 'Log CFC';
					break;
				case "/component-file":
					$scope.currentNavItem = 'cfc-file';
					$scope.currentPageTitle = 'File CFC';
					break;
				case "/component-extra":
					$scope.currentNavItem = 'cfc-extra';
					$scope.currentPageTitle = 'Extras CFC';
					break;
				case "/component-dbs":
					$scope.currentNavItem = 'cfc-dbs';
					$scope.currentPageTitle = 'Database CFC';
					break;
				case "/component-table":
					$scope.currentNavItem = 'cfc-table';
					$scope.currentPageTitle = 'Table CFC';
					break;
				case "/usage":
					$scope.currentNavItem = 'usage';
					$scope.currentPageTitle = 'How to Use';
					break;
				default:
					$scope.currentNavItem = '';
					$scope.currentPageTitle = '';
					break;
			}
		}
	);

	console.log($scope);
})

function DialogController($scope, $mdDialog) {
	$scope.hide = function() {
		// console.log($scope);
		$mdDialog.hide();
	};

	$scope.cancel = function() {
		$mdDialog.cancel();
	};
}

document.addEventListener("DOMContentLoaded", function(event) {
	Prism.highlightAll(true);
});
