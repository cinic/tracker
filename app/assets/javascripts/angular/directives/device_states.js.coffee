Zoomator.directive "deviceStates", ["$compile",
  ($compile) ->

    scope:
      inStates: "="
      inStateSelected: "="
    templateUrl: "device_state_tmpl.html"
    replace: true
    restrict: "E"
    controller: ($scope, $element) ->

      $scope.addMap = (index) ->
        $element.find("tr.yamap").remove()


        maptpl = "<tr class='yamap'><td colspan='6'>" +
                 "<div class='close-map' ng-click='closeMap()'>Закрыть</div>" +
                 "<div id='map' style='width:100%;height:245px;'>" +
                 "<ya-map ya-zoom='8' ya-center='{{geoObject.geometry.coordinates}}' ya-controls='smallMapDefaultSet'>" +
                 "<ya-geo-object ya-source='geoObject'></ya-geo-object>" +
                 "</ya-map>" +
                 "</div>" +
                 "</td></tr>"

        map = $compile( maptpl )( $scope )
        $element.find("tr.state#{index}").after(map)

      $scope.closeMap = ->
        $scope.inStateSelected = null
        $element.find("tr.yamap").remove()

      $scope.setSelected = (index) ->
        $scope.inStateSelected = $scope.inStates[index]

        $scope.geoObject = 
          geometry:
            type: 'Point'
            coordinates: _.map($scope.inStateSelected.gis.split(","), (e) -> Number e).reverse()

        $scope.addMap(index)

      $scope.activeClass = (index) ->
        if $scope.inStateSelected == $scope.inStates[index] then "active" else ""
        
     
]