// Display prices as '$'
tinyHouseApp.directive('cost', function() {
  return {
    restrict: 'E',
    scope: {
      cost: '=value'
    },
    templateUrl: '/partials/cost.html'
  };
});

// Make tooltips work
tinyHouseApp.directive('tooltip', function(){
  return {
    restrict: 'A',
    link: function(scope, element, attrs){
      $(element).tooltip();
    }
  };
});
