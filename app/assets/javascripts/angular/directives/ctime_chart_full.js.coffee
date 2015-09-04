Zoomator.directive "ctimeChartFull", [
  "WrapText", 
  "LocaleService"
  "PrepareData"
  (WrapText, LocaleService, PrepareData) ->

    link = (scope, element) ->

      # result = [
      #   {kind: "averageNorm", val: averageNorm, desc: "среднее в нормоцикле (СН)"},
      #   {kind: "averageFailAndAcl", val: averageFailAndAcl, desc: "среднее со сбоями и ускорениями (ССУ)"}
      #   {kind: "target", val: target, desc: "целевое (Ц)"}
      # ]
      
      # settings

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

        console.log "ctime defailt data", data

        svg.selectAll('*').remove()
        return unless data
        
        widthOffset = width / 10
        widthDetailed = width - widthOffset

        detail = svg.append("g")
                    .attr("transform", "translate(#{widthOffset},#{marginTop})")
                    .attr("class", "detail-chart")

        x = d3.time.scale()
                   .range([0, widthDetailed])
        y = d3.scale.linear()
                    .rangeRound([height/2, 0])

        xAxis = d3.svg.axis()
                  .scale(x)
                  .orient("bottom")
                  .tickFormat(LocaleService.RU().timeFormat("%d %B"))
                  .ticks(8)

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

        # barWidth = (2 * width / 3) / data.length / 3
        # barGroupWidth = (2 * width / 3) / data.length / 2
        # barShift = barWidth / 3

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
                .attr("fill", (d) -> PrepareData.getColorForCtime(d.kind))

        detail.append("g")
              .attr("class", "x axis")
              .attr("transform", "translate(0,#{height/2})")
              .call(xAxis)
        
        if scope.legend != 'hide'
          legendRectSize = 18
          legendSpacing = 4

          legendArea = svg.append("g")
                      .attr("transform", "translate(#{width / 10},#{2 * height / 3})")
                      .attr("class", "detail-legend")

          legendData =  [
             {label: 'ssn', desc: "среднее в нормоцикле (СН)"}, 
             {label: 'ssu', desc: "среднее со сбоями и ускорениями (ССУ)"}, 
             {label: 'targ', desc: "целевое (Ц)"}
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
            .style('fill', (d) -> PrepareData.getColorForCtime(d.label))

          legend.append('text')
            .text (d) -> "- #{d.desc}"
            .attr("transform", "translate(#{legendRectSize * 1.5}, #{legendRectSize * 0.7})")
          
    scope:
      chartData: "="
      legend: "@"
    template: "<div></div>" 
    restrict: "E"
    replace: true
    link: link
]