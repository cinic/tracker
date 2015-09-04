Zoomator.directive "zoom", [ 
  ->

    replace: true
    restrict: "E"
    templateUrl: "zoom_tmpl.html"
    scope:
      start: "="
      end: "="
      max: "@"
      min: "@" 

    controller: ($scope) -> 

      setZposition = (zvalue) ->
        switch zvalue
          when 3 then 50
          when 2 then 25
          when 1 then 0
          when 4 then 75
          when 5 then 100
          else return

      baseZoomValue = 3

      currentZoomValue = baseZoomValue

      $scope.currentZposition = setZposition(currentZoomValue)

      duration = $scope.end - $scope.start


      $scope.zoomIn = () ->

        return unless currentZoomValue < 5
        
        newstart = $scope.start + duration/4
        newend = $scope.end - duration/4


        newstart = +$scope.min if newstart < +$scope.min
        newend = +$scope.max if newend > +$scope.max 

        currentZoomValue += 1
        $scope.currentZposition = setZposition(currentZoomValue)

        $scope.start = newstart
        $scope.end = newend

        duration = $scope.end - $scope.start

      $scope.zoomOut = () ->

        return unless currentZoomValue > 1

        newstart = $scope.start - duration/2
        newend = $scope.end + duration/2

        if newstart < +$scope.min
          diff = +$scope.min - newstart
          newstart = +$scope.min 
          newend = newend + diff


        if newend > +$scope.max 
          diff = newend - +$scope.max
          newend = +$scope.max
          newstart = newstart - diff
        

        currentZoomValue -= 1
        $scope.currentZposition = setZposition(currentZoomValue)

        $scope.start = newstart
        $scope.end = newend

        duration = $scope.end - $scope.start
]
