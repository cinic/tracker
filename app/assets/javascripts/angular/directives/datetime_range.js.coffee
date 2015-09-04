Zoomator.directive "datetimeRange", () ->

  templateUrl: "datetime_range_tmpl.html"
  restrict: "E"
  replace: true
  controller: ($scope) ->

    $scope.lastLeftRunnerDatetime = $scope.selectedPeriod.startDatetime
    $scope.lastRightRunnerDatetime = $scope.selectedPeriod.endDatetime


    $scope.$watch "selectedPeriod.startDatetime", ((newval, oldval) ->
      if newval != oldval
        $scope.lastLeftRunnerDatetime = $scope.selectedPeriod.startDatetime
      ), true

    $scope.$watch "selectedPeriod.endDatetime", ((newval, oldval) ->
      if newval != oldval
        $scope.lastRightRunnerDatetime = $scope.selectedPeriod.endDatetime
      ), true

    

    $scope.showPicker = (e, pickType) ->
      e.stopPropagation()
      $scope.datetimePicker.posY = e.clientY
      $scope.datetimePicker.posX = e.clientX
      $scope.datetimePicker.show = !$scope.datetimePicker.show
      $scope.datetimePicker.pickType = pickType




