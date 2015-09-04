Zoomator.directive "perfChartFull", [
  "LocaleService"
  "PrepareData"
  (LocaleService, PrepareData) ->

    link = (scope, element, attrs) ->
      width = angular.element(element[0]).width()
      marginTop = 40
      tickPadding = 15
      height = 450

      angular.element(element[0]).height(height)

      svg = d3.select(element[0])
              .append("svg")
              .style('width', width)
              .style('height', height)

      # watch for changes
      scope.$watch "chartData", ((newval) ->
        if newval
          console.log "perf data full", newval
          render newval
        ), true

      render = (data) ->
        svg.selectAll('*').remove()
        return unless data
        return if _.isEmpty data

        widthDetailed = width
        widthOffset = width / 10

        detail = svg.append("g")
                    .attr("transform", "translate(#{widthOffset}, #{marginTop})")
                    .attr("class", "detail-chart")

        x = d3.time.scale()
                   .range([0, widthDetailed])

        y = d3.scale.linear()
                    .rangeRound([height/2, 0])

        # x1 = d3.scale.ordinal()

        xAxis = d3.svg.axis()
                  .scale(x)
                  .orient("bottom")
                  .ticks(8)
                  .tickFormat(LocaleService.RU().timeFormat("%d %B"))

        x.domain( d3.extent(data, (d) -> d.date ) )

        y.domain( [0, d3.max(data, (d) ->
          d3.max(d.values, (dd) -> dd.val)
         )] )

        yAxis = d3.svg.axis().scale(y)
                         .orient("left")
                         .innerTickSize(-widthDetailed)
                         .outerTickSize(0)
                         .ticks(4)

        detail.append("g")
              .attr("class", "y axis")
              .call(yAxis)
              
        barWidth = (widthDetailed) / data.length / 3
        barGroupWidth = (widthDetailed) / data.length / 2
        barShift = barWidth / 3
        interval = detail.selectAll(".interval")
                         .data(data)
                         .enter()
                         .append("g")
                         .attr("class", "g")
                         .attr("transform", (d, i) -> "translate(#{x(d.date)},0)")

        interval.selectAll("rect")
                .data((d) -> d.values)
                .enter()
                .append("svg:rect")
                .attr("x", (d, i) -> (-i * barShift) + barShift*3 )
                .attr("height", (d) -> height/2 - y(d.val))
                .attr("y", (d) -> y(d.val))
                .attr("width", barWidth)
                .attr("fill", (d) -> PrepareData.getColorForPerf(d.kind))
        
        detail.append("g")
              .attr("class", "x axis")
              .attr("transform", "translate(0, #{height/2})")
              .call(xAxis)

        detail.select(".y")
          .selectAll("g.tick")
          .select("text")
          .attr("transform", "translate(-#{tickPadding})")

        legendRectSize = 18
        legendSpacing = 4

        legendArea = svg.append("g")
                    .attr("transform", "translate(#{width / 10}, #{2 * height / 3})")
                    .attr("class", "detail-legend")

        legendData =  [
          {label: 'fact', desc: "фактически (факт)"}, 
          {label: 'pos', desc: "потери от сбоев (ПОС)"}, 
          {label: 'pop', desc: "потери от простоев (ПОП)"}
        ]

        legend = legendArea.selectAll('.modes-legend')
          .data(legendData)
          .enter()
          .append('g')
          .attr('class', 'modes-legend')
          .attr 'transform', (d, i) ->
            offset =  2* width / 9 * i
            horz = offset
            "translate(#{horz})"

        legend.append('rect')
          .attr('width', legendRectSize)
          .attr('height', legendRectSize)
          .style('fill', (d) -> PrepareData.getColorForPerf(d.label))

        legend.append('text')
          .text (d) -> "- #{d.desc}"
          .attr("transform", "translate(#{legendRectSize * 1.5}, #{legendRectSize * 0.7})")

    scope:
      chartData: "="
    template: "<div></div>" 
    restrict: "E"
    replace: true
    link: link
]