Zoomator.directive "consumpChartFull", ["LocaleService"
  (LocaleService) ->

    link = (scope, element) ->

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
          render newval
        ), true

      # render chart

      render = (data) ->

        svg.selectAll('*').remove()

        return unless data

        # detailed
        widthOffset = width / 10
        widthDetailed = width - widthOffset
        detail = svg.append("g")
                    .attr("transform", "translate(#{widthOffset},#{marginTop})")
                    .attr("class", "detail-chart")

        x = d3.time.scale()
                   .range([0, widthDetailed])
                   # .nice(d3.time.day)

        y = d3.scale.linear()
                    .rangeRound([height/2, 0])

        xAxis = d3.svg.axis()
                  .scale(x)
                  .orient("bottom")
                  .ticks(8)
                  .tickFormat(LocaleService.RU().timeFormat("%d %B"))

        x.domain( d3.extent(data, (d) -> d.date ) )

        y.domain( [0, d3.max(data, (d) -> d.val )] )

        barWidth = Math.round( width / 3 / data.length )

        yAxis = d3.svg.axis().scale(y)
                     .orient("left")
                     .innerTickSize(-widthDetailed)
                     .outerTickSize(0)
                     .ticks(4)

        detail.append("g")
              .attr("class", "y axis")
              .call(yAxis)

        detail.selectAll("rect")
              .data(data)
              .enter()
              .append("svg:rect")
              .attr("x", (d) -> x(d.date) + 3 * barWidth / 2)
              .attr("height", (d) -> height/2 - y(d.val))
              .attr("y", (d) -> y(d.val))
              .attr("width", barWidth)
              .attr("fill", "#d9a0ea")

        detail.append("g")
              .attr("class", "x axis")
              .attr("transform", "translate(0,#{height/2})")
              .call(xAxis)
        
    scope:
      chartData: "="
    template: "<div></div>" 
    restrict: "E"
    replace: true
    link: link
]