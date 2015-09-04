Zoomator.directive "marker", [ 
  ->
    scope:
      markerPosition: '='
      markerHeight: '='
      markerDatetime: '='
      zoomColors: '='
    restrict: "EA"
    replace: true
    templateUrl: 'marker.html'
    controller: ($scope) ->
      $scope.markerTop = 220
      $scope.markerWidth = 20


    link: (scope, elem, attr) ->



      paper = Snap elem.find("#markerSvg")[0]

      scope.$watchCollection "zoomColors" , (newval) ->
        if newval
          console.log(newval)


    

     
     

      

      # isOnWorkinkCgraph = ->

      # paper = Snap '#markersvg'

      # # c = paper.circle 10, 200, 8
      # #          .attr {fill: '#fff', stroke: '#64a8dd', strokeWidth: 1}

      # c = paper.circle 10, 200, 8
      #      .attr {fill: '#fff', stroke: '#64a8dd', strokeWidth: 1}

      # scope.$watch 'markerPosition', (newval) ->
      #   if newval
      #     elem.find('svg').height('100%').width('20px')
      #     getCrossPositions = ->
      #       cords = []
      #       _.each angular.element('.charts'), (ele) ->
      #         cords.push {
      #           x: scope.markerPosition, 
      #           y: (ele.getBoundingClientRect().top + ele.getBoundingClientRect().height/2)
      #         }
      #       cords

      #     # getMarkerColor: ->

      #     # if !c 
      #     #   c = paper.circle 10, 200, 8
      #     #            .attr {fill: '#fff', stroke: '#64a8dd', strokeWidth: 1}
      #     paper.select('circle').attr('cx', scope.markerPosition)

         
        

     
]     
