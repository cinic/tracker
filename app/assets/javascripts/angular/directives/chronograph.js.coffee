Zoomator.directive "chronograph", [
  "$filter" 
  "$q" 
  "IntervalService" 
  "$window"
  "Dataset"
  "Clamp"
  ($filter, $q, IntervalService, $window, Dataset, Clamp) ->
    

    link = (scope, el, attr) ->


      drawChart = () ->
        cont_w = angular.element(".charts").width()
        contH = angular.element(".charts").height()
        dataset = scope.dataset
        el.html('')


        scale = d3.scale.linear()
                  .domain([
                    0
                    d3.sum(dataset, (d) -> d.width)
                  ])
                  .range([
                    0
                    cont_w
                  ])

        scaledDs = _.map dataset, (n) ->  

          result =
            fromTs: n.fromTs
            toTs: n.toTs
            width: scale(n.width) 
            type: n.type
            fromX: scale(n.fromX)
            toX: scale(n.toX)
            color: n.color

          result 



        tip = d3.tip()
                .attr("class", "d3-tip")
                .direction('s')
                .offset ->
                  if @getBBox().cx
                    if @getBBox().cx > cont_w / 2
                      [5, -@getBBox().width]
                    else
                      [5, @getBBox().width]
                  else
                    [5,0]
  
                .html (d) ->
                
                  mode = switch d.type 
                    when "acl" then "ускоренный"
                    when "fail" then "сбой"
                    when "idle" then "простой"
                    when "norm" then "нормоцикл"
                    else "нет данных"
                      
                  "период: #{$filter('date')(d.fromTs, 'dd MMMM yyyy HH:mm')} - #{$filter('date')(d.toTs, 'dd MMMM yyyy HH:mm')}" + "</br>" +
                  "длительность: #{$filter('duration')(d.width, 'dd д hh ч mm м ss с')}" + "</br>" +
                  "режим: #{mode}"


    
        svg = d3.select(el[0]).append("svg").attr("width", cont_w).attr("height", 60)

        pattern = svg.append('defs')
                     .append('pattern')
                        .attr('id', 'diagonalHatch')
                        .attr('patternUnits', 'userSpaceOnUse')
                        .attr('width', 10)
                        .attr('height', 10)
                        .attr('x', 0)
                        .attr('y', 0)

        patternG = pattern.append('g')
                          .attr("fill", "#d7d5d5")
                          .attr("stroke", '#fff')
                          .attr("stroke-width", 1)

        patternG.append('path')
            .attr('d', 'M0,0 l10,10')
   

        patternG.append('path')
            .attr('d', 'M10,0 l-10,10')
      

        svg.selectAll("rect").data(dataset).enter().append("rect")
          .attr "fill", (d) ->
            if d["color"] == "nodata"
              "url(#diagonalHatch)"
            else
              d["color"]
          .attr("height", 60)
          .attr "x", (d, i) ->
            scale d["fromX"]
          .attr "width", (d) ->
            scale d["width"]

        getZoomColor = (dt) ->
          result = _.find scaledDs, (n) ->
            n.fromTs < dt < n.toTs
          if result then result.color else "#ffffff"


        svg.call tip
        svg.selectAll("rect")
           .on("mouseover", tip.show)
           .on("mouseout", tip.hide)

        scope.$watch "markerPosition", (newval) ->
          scope.zoomColor = getZoomColor(scope.markerDatetime)

      

      scope.$watch (-> scope.intervals()), (newval) ->
        if newval && newval != _.isEmpty
          scope.dataset = (new Dataset(scope.start, scope.end, newval)).data
          drawChart()

      
      
        
    replace: true
    template: "<div class='chronograph'></div>"
    scope:
      zoomColor: "="
      start: "@"
      end: "@"
      markerPosition: "@"
      markerDatetime: "@"
      intervals: "&"
      did: "@"
    link: link
    restrict: "E"
    controller: ($scope) ->
      $scope.$watch "did", (newval) ->
        if newval
          Clamp.findAll(newval)
               .then (result) ->
                  $scope.clamps = result.data.clamps
]