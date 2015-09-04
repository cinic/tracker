Zoomator.directive "ctimeChart", [
  "WrapText"
  "PrepareData"
  (WrapText, PrepareData) ->

    link = (scope, element, attrs) ->

      marginTop = 50
      marginLeft = 150
      tickPadding = 15
      width = angular.element(element[0]).width()
      height = 450

      angular.element(element[0]).height(height)

      svg = d3.select(element[0])
              .append("svg")
              .style('width', width)
              .style('height', height)

      # scope.$on "selectedPeriod:updated", () ->
      #   if PrepareData.isPrepared
      #     render PrepareData.getCtimeData()
      #     
      
      scope.$watch "chartData", ((newval) ->
          if newval && !_.isEmpty(newval)
            render(_.compact newval)
        ),true
      
      renderNoData = ->
        svg.append("text")
              .attr("class", "no-data")
              .attr("x", width / 2)
              .attr("y", height / 3)
              .attr("text-anchor", "middle")
              .text("Нет данных")

      # render chart function
      render = (data) ->
        svg.selectAll('*').remove()
        return renderNoData() unless data
        return renderNoData() if _.isEmpty(data)

        chart = svg
                .append("g")
                .attr("transform", "scale(0.5) translate(#{marginLeft}, #{marginTop})")

        x = d3.scale.linear().domain([0, data.length]).range([0, width])

        y = d3.scale.linear().domain([0, d3.max(data, (d) -> d.val)]).rangeRound([height, 0])

        yAxis = d3.svg.axis().scale(y)
                  .orient("left")
                  .innerTickSize(-width)
                  .outerTickSize(0)
                  .ticks(4)

        chart.append("g")
              .attr("class", "y axis")
              .call(yAxis)

        chart.selectAll("rect").
          data(data).
          enter().
          append("svg:rect").
          attr("x", (d, i) -> x(i) + 50).
          attr("height", (d) -> 
            result = height - y(d.val)
            if result < 1
              1
            else
              result
          ).
          attr("y", (d) -> 
            result = y(d.val)
            if result > height - 4
              height - 4
            else
              result
          ).
          attr("width", 160).
          attr("fill", (d) -> PrepareData.getColorForCtime(d.kind))

        chart.append("line")
             .attr("class", "x axis")
             .attr("x1", 0)
             .attr("x2", width)
             .attr("y1", height)
             .attr("y2", height)
             .attr("stroke", "#e7e8ea")
             .attr("stroke-width", 4)

        if scope.legend != 'hide'
          legendRectSize = 18
          legendSpacing = 4

          legend = svg.selectAll('.ctime-legend')
            .data(data)
            .enter()
            .append('g')
            .attr('class', 'ctime-legend')
            .attr 'transform', (d, i) ->
              offset =  width / 3 * i
              horz = offset
              vert = 285
              "translate(#{horz + 50},#{vert})"

          legend.append('rect')
            .attr('width', legendRectSize)
            .attr('height', legendRectSize)
            .style('fill', (d) -> PrepareData.getColorForCtime(d.kind))

          legend.append('text')
            .text (d) -> "- #{d.desc}"
            .attr("transform", "translate(#{legendRectSize * 1.5}, #{legendRectSize * 0.7})")
            .attr("dy", 0)
            .call(WrapText.wrap, 120)

    scope:
      chartData: "="
      legend: "@"
    template: "<div></div>" 
    restrict: "E"
    replace: true    
    link: link
]