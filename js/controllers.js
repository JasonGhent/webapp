tinyHouseApp.controller('aboutController', function($scope, $http) {
  $http.get('data/people.json').success(function(data) {
    $scope.people = data;
  });
});

tinyHouseApp.controller('communityController', function($scope, $http) {
  // Get a list of groups 
  // TODO XXX Get in a database, allow users to fill in a form to suggest a community
  $http.get('data/groups.json').success(function(data) {
    $scope.groups = data;
  });

  // Make sure USA is at the top of the community groups
  $scope.usaToTheTop = function(group) {
    if (group.country == "USA") {
      return -1;
    }
    else {
      return group.country;
    }
  }
});

tinyHouseApp.controller('contactController', function($scope) {
});

tinyHouseApp.controller('newsController', function($scope) {
});
