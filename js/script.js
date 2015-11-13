var tinyHouseApp = angular.module('tinyHouseApp', ['ngRoute']);

tinyHouseApp.config(function($routeProvider, $locationProvider) {
  $routeProvider
    .when('/about', {
      templateUrl : 'partials/about.html',
      controller  : 'aboutController'
    })
    .when('/contact', {
      templateUrl : 'partials/contact.html',
      controller  : 'contactController'
    })
    .when('/news', {
      templateUrl : 'partials/news.html',
      controller  : 'newsController'
    })
    .otherwise({
      redirectTo: '/about'
    });

  // use the HTML5 History API
  $locationProvider.html5Mode(true);
});

tinyHouseApp.controller('aboutController', function($scope, $http) {
  $http.get('json/people.json').success(function(data) {
    $scope.people = data;
  });
});

tinyHouseApp.controller('contactController', function($scope) {
  // create a message to display in our view
});


tinyHouseApp.controller('newsController', function($scope) {
  // create a message to display in our view
});
