Zoomator.directive "modesChartFull", [
  "LocaleService"
  "PrepareData"
  (LocaleService, PrepareData) ->

    link = (scope, element) ->

      # settings
      width = widthDetailed = angular.element(element[0]).width()
      marginTop = 40
      marginLeft = 80
      tickPadding = 15
      height = 450
      angular.element(element[0]).height(height)

      svg = d3.select(element[0])
              .append("svg")
              .style('width', width)
              .style('height', height)

      # watch for data changes
      # scope.$on "selectedPeriod:updated", () ->
      #   if !_.isEmpty scope.chartData
      #     render scope.chartData
      
      scope.$watch "chartData", ((newval) ->
          if newval && !_.isEmpty(newval)
            render newval
        ),true

      # render chart 
      render = (data) ->
        svg.selectAll('*').remove()
        return unless data
        return if _.isEmpty data

        detail = svg.append("g")
                    .attr("transform", "translate(#{marginLeft}, #{marginTop})")
                    .attr("class", "detail-area")

        x = d3.time.scale()
                   .range([0, widthDetailed - marginLeft])

        y = d3.scale.linear()
                    .range([height/2 , 0])

        xAxis = d3.svg.axis()
                  .scale(x)
                  .orient("bottom")
                  .ticks(8)
                  .tickFormat(LocaleService.RU().timeFormat("%d %B"))

        area = d3.svg.area()
                     .x (d) -> x(d.date)
                     .y0 (d) -> y(d.y0) 
                     .y1 (d) -> y(d.y0 + d.y)

        stack = d3.layout.stack()
                  .values((d) -> d.values)

        _.each data, (d) -> d.date = new Date d.date

        layersNames = ["sa", "sf", "si", "sn"]

        modes = _.map layersNames, (name) ->
          name: name,
          values: _.map data, (d) ->
            {
              date: d.date,
              y: d[name]
            }

        y.domain( [0, d3.max( _.map(data, (d) -> d.sa + d.sf + d.si + d.sn) )] )
        
        modesStacked = stack modes

        x.domain( d3.extent(data, (d) -> d.date ) )

        yAxis = d3.svg.axis().scale(y)
                         .orient("left")
                         .innerTickSize(-widthDetailed)
                         .outerTickSize(0)
                         .ticks(4)
                         .tickFormat((d) -> 
                          if scope.displayIn == 'timeInPercent' || scope.displayIn == 'cyclesInPercent'
                            console.log(d)
                            "#{d*10000} %"
                          else
                            d)

        mode = detail.selectAll(".device-mode")
            .data(modesStacked)
            .enter().append("g")
            .attr("class", "device-mode");

        mode.append("path")
            .attr("class", "area")
            .attr("d", (d) -> area(d.values))
            .style("fill", (d) -> PrepareData.getColorForModes(d.name))

        detail.append("g")
              .attr("class", "x axis")
              .attr("transform", "translate(0,#{height/2})")
              .call(xAxis)

        detail.append("g")
              .attr("class", "y axis modes")
              .call(yAxis)
        
        detail.selectAll("g.tick")
          .select("line")
          .attr("class", "area-line")
          .style "stroke-width", 1

        detail.select(".y")
          .selectAll("g.tick")
          .select("text")
          .attr("transform", "translate(-#{tickPadding})")

        legendRectSize = 18
        legendSpacing = 4
        labelOffset = width / 5

        legendData =  [
          {label: 'sn', desc: "работа в нормоцикле (Н)"},
          {label: 'sa', desc: "работа в ускоренном цикле (У)"},
          {label: 'sf', desc: "работа со сбоями цикла (С)"},
          {label: 'si', desc: "простой (П)"}
        ]

        legendArea = svg.append("g")
                    .attr("transform", "translate(#{width/10}, #{2*height/3})")
                    .attr("class", "detail-legend")

        legend = legendArea.selectAll('.modes-legend')
          .data(legendData)
          .enter()
          .append('g')
          .attr('class', 'modes-legend')
          .attr 'transform', (d, i) -> "translate(#{labelOffset * i}, 0)"

        legend.append('rect')
          .attr('width', legendRectSize)
          .attr('height', legendRectSize)
          .style('fill', (d) -> PrepareData.getColorForModes(d.label))

        legend.append('foreignObject')
          .attr("width", 2*labelOffset/3)
          .attr("height", labelOffset/2)
          .html (d) -> d.desc
          .attr("transform", "translate(#{Math.ceil legendRectSize * 1.5}, 0)")

    scope:
      chartData: "="
      displayIn: "@"
    template: "<div></div>" 
    restrict: "E"
    replace: true
    link: link
]