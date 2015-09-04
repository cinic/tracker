Zoomator.directive "timelineMenu", [
  "FullPeriod"
  (FullPeriod) ->

    scope:
      selectedPeriod: "="
    replace: true
    restrict: "EA"
    templateUrl: "timeline_menu_tmpl.html"
    controller: ($scope) ->

      $scope.changePeriod = (arg) ->

        baseStartTime = new Date().setHours(0,0,0,0)
        baseEndTime = new Date().setHours(23,59,59,999)
        h24 = 24 * 60 * 60 * 1000
        
        switch arg
          when "today"
            $scope.selectedPeriod.startDatetime = baseStartTime
            $scope.selectedPeriod.endDatetime = baseEndTime
            $scope.changedPeriod = "today"
          when "yesterday"
            $scope.selectedPeriod.startDatetime = baseStartTime - h24
            $scope.selectedPeriod.endDatetime = baseEndTime - h24
            $scope.changedPeriod = "yesterday"
          when "week"
            $scope.selectedPeriod.startDatetime = baseStartTime - 7 * h24
            $scope.selectedPeriod.endDatetime = baseEndTime
            $scope.changedPeriod = "week"
          when "month"
            $scope.selectedPeriod.startDatetime = baseStartTime - 30 * h24
            $scope.selectedPeriod.endDatetime = baseEndTime
            $scope.changedPeriod = "month"
          when "year"
            newdate = baseStartTime - 365 * h24
            if newdate < FullPeriod.startDatetime
              $scope.selectedPeriod.startDatetime = FullPeriod.startDatetime
            else
              $scope.selectedPeriod.startDatetime = newdate
            $scope.selectedPeriod.endDatetime = baseEndTime
            $scope.changedPeriod = "year"
          when "all"
            $scope.selectedPeriod.startDatetime = FullPeriod.startDatetime
            $scope.selectedPeriod.endDatetime = FullPeriod.endDatetime
            $scope.changedPeriod = "all"

      $scope.changedPeriod = "custom" 

  
]
