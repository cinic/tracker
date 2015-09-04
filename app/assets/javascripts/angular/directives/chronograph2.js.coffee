Zoomator.directive "chronograph2", [
  "$filter" 
  "$q" 
  "IntervalService" 
  "$window"
  "Dataset"
  "Clamp"
  ($filter, $q, IntervalService, $window, Dataset, Clamp) ->

    colorForMode = (type) ->
      switch type
        when "acl" then "#a1d1f3"
        when "norm" then "#a4dc85"
        when "idle" then "#eeb679"
        when "fail" then "#f87e72"
        when "nodata" then "#e3e5e6"
        else "#e3e5e6"


    link = (scope, el, attr) ->

      drawChart = () ->
        cont_w = angular.element(".charts").width()
        contH = 60

        el.html('')

        scale = d3.scale.linear()
                  .domain([0, +scope.end - +scope.start])
                  .range([0, cont_w])

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


      

        svg.selectAll("rect").data(scope.dataset).enter().append("rect")
          .attr "fill", (d) ->
            if d.type == "nodata"
              "url(#diagonalHatch)"
            else
              colorForMode(d.type)
          .attr("height", 60)
          .attr "x", (d, i) ->
            scale d["fromX"]
          .attr "width", (d) ->
            scale d["width"]

        svg.call tip
        svg.selectAll("rect")
           .on("mouseover", tip.show)
           .on("mouseout", tip.hide)


        svg.append('circle')
           .attr('cx', scale(scope.markerDatetime - scope.start))
           .attr('cy', contH / 2)
           .attr('r', 12)
           .attr('stroke', '#76b7e4')
           .attr('stroke-width', '1px')
           .attr('fill', '#e3e5e6')


        scope.$watch "markerDatetime", (newval, oldval) ->
          # if newval && newval != oldval
            
            found = _.find scope.dataset, (n) ->
              n.fromTs < newval < n.toTs
            svg.select('circle')
               .attr('fill', colorForMode(found.type))
               .attr('cx', scale(newval - scope.start))

              



      scope.$watch "dataset", ((newval) -> 
        drawChart() if newval), true
      
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
      $scope.$watchGroup ["did", "start", "end"], (newvalues) ->
        if newvalues
          if newvalues[0] && newvalues[1] && newvalues[2]
            Clamp.findAll(newvalues[0], newvalues[1], newvalues[2])
               .then (result) ->
                  if !_.isEmpty result.clamps
                    $scope.dataset = 
                      _(result.clamps).map (x,i) ->
                        if i == 0
                          drn = x.ts - +$scope.start
                          type = 'nodata'
                          fromX = 0
                          toX = drn
                          fromTs = +$scope.start
                          toTs = x.ts
                        else
                          drn = +x.ts - +result.clamps[i-1].ts
                          type = x.type
                          fromX = +result.clamps[i-1].ts - +$scope.start
                          toX = fromX + drn
                          fromTs = result.clamps[i-1].ts
                          toTs = x.ts

                        width: +drn
                        fromX: +fromX
                        toX: +toX
                        fromTs: +fromTs
                        toTs: +toTs
                        type: type
                      .value()
                    $scope.dataset.push({
                        width: +$scope.end - _.last($scope.dataset).toTs,
                        type: 'nodata',
                        fromX: _.last($scope.dataset).toTs - $scope.start,
                        toX: +$scope.end - $scope.start,
                        fromTs: _.last($scope.dataset).toTs,
                        toTs: +$scope.end
                      })
                  else
                    $scope.dataset = []
                    $scope.dataset.push({
                        width: +$scope.end - +$scope.start,
                        type: 'nodata',
                        fromX: 0,
                        toX: +$scope.end - +$scope.start,
                        fromTs: +$scope.start,
                        toTs: +$scope.end
                      })

                  $scope.dataset
                  





                  
]