Zoomator.directive "batt", [
  () ->

    scope:
      vBatt: "@"
    template: "<span class='batt-icon {{battCharge}}'></span>"
    restrict: "E"
    replace: true
    controller: ($scope) ->

      getBattCharge = (v_batt) ->
        # console.log v_batt
        switch 
          when 3.2 < (Number v_batt) then "norm"
          else
            "low"

      $scope.$watch "vBatt", (newval) ->
        $scope.battCharge = getBattCharge(newval)
  
]