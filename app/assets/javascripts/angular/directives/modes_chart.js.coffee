Zoomator.directive "modesChart", [
  "WrapText"
  "PrepareData"
  (WrapText, PrepareData) ->

    link = (scope, element) ->

      width = angular.element(element[0]).width()
      marginTop = 40
      height = 450
      angular.element(element[0]).height(height)

      svg = d3.select(element[0])
              .append("svg")
              .style('width', width)
              .style('height', height)
              .append("g")
              .attr("transform", "translate(" + width / 2 + "," + (height / 4 + marginTop) + ")")

      # scope.$on "selectedPeriod:updated", () ->
      #   if PrepareData.isPrepared
      #     render PrepareData.getModesData()
      # 
      #     
      # isEmptyChartData = (cdata) ->
      #   0 == _.reduce cdata, ((sum, n) ->
      #        sum += n['val']
      #     ), 0    
      
      scope.$watch "chartData", ((newval) ->
          if newval && !_.isEmpty(newval)
            render newval
        ),true
        
      renderNoData = ->
        svg.append("text")
              .attr("class", "no-data")
              .attr("x", 0)
              .attr("y", 0)
              .attr("text-anchor", "middle")
              .text("Нет данных")

      render = (data) ->
        data = _.compact data
        svg.selectAll('*').remove()
        return renderNoData() if !data || _.isEmpty(data)

        tot = _.reduce data, ((sum, n) -> sum += n.val), 0

        radius = Math.min(width, height) / 4
        cDim = 
          labelRadius: radius + 10

        pie = d3.layout.pie().value((d) -> d.val)

        arc = d3.svg.arc()
                .outerRadius(radius - 10)
                .innerRadius(0)

        getArcSize = (d) ->
          frac = d/tot * 100
          switch 
            when frac > 30
              'norm'
            else
              'small'

        arcs = svg.selectAll(".arc")
                  .data(pie(data))
                  .enter().append("g")
                  .attr "class", (d) ->
                    "arc #{d.data.kind} #{getArcSize(d.data.val)}"

        arcs.append("path")
              .attr("d", arc)
              .style "fill", (d) ->
                PrepareData.getColorForModes(d.data.kind)
              .attr("transform", (d) ->
                dist = 2
                d.midAngle = ((d.endAngle - d.startAngle) / 2) + d.startAngle
                x = Math.sin(d.midAngle) * dist
                y = -Math.cos(d.midAngle) * dist
                "translate(#{x},#{y})"
              )

        normalArcs = svg.selectAll(".norm")
        smallArcs = svg.selectAll(".small")

        normalArcs.append("text")
              .attr "transform", (d) -> "translate(#{arc.centroid(d)})"
              .attr("dy", ".35em")
              .style("text-anchor", "middle")
              .attr("fill", "#fff")
              .text (d) ->
                # if scope.modesDisplayIn == "cyclesInPercent" || scope.modesDisplayIn == "timeInPercent"
                #   "#{(Number d.data.val).toFixed(1)}%"
                # else
                  Math.round (Number d.data.val)
              .attr("font-size", "140%")

        labelGroups = smallArcs.append("g").attr("class", "label")

        labelGroups.append("circle").attr({
            x: 0,
            y: 0,
            r: 2,
            fill: "#9ba4b3",
            transform: (d) ->
              "translate(#{arc.centroid(d)})"
            })
            
        textLines = labelGroups.append("line").attr(
          x1: (d, i) ->
            arc.centroid(d)[0]

          y1: (d, i) ->
            arc.centroid(d)[1]

          x2: (d, i) ->
            centroid = arc.centroid(d)
            midAngle = Math.atan2(centroid[1], centroid[0])
            x = Math.cos(midAngle) * cDim.labelRadius
            x

          y2: (d, i) ->
            centroid = arc.centroid(d)
            midAngle = Math.atan2(centroid[1], centroid[0])
            y = Math.sin(midAngle) * cDim.labelRadius
            y
          class: "label-line"
        )

        textLabels = labelGroups.append("text").attr(
          x: (d, i) ->
            centroid = arc.centroid(d)
            midAngle = Math.atan2(centroid[1], centroid[0])
            x = Math.cos(midAngle) * cDim.labelRadius
            sign = (if (x > 0) then 1 else -1)
            labelX = x + (5 * sign)
            labelX

          y: (d, i) ->
            centroid = arc.centroid(d)
            midAngle = Math.atan2(centroid[1], centroid[0])
            y = Math.sin(midAngle) * cDim.labelRadius
            y

          "text-anchor": (d, i) ->
            centroid = arc.centroid(d)
            midAngle = Math.atan2(centroid[1], centroid[0])
            x = Math.cos(midAngle) * cDim.labelRadius
            (if (x > 0) then "start" else "end")

          class: "label-text"

        ).text((d) ->
            # if scope.modesDisplayIn == "cyclesInPercent" || scope.modesDisplayIn == "timeInPercent"
            #   "#{(Number d.data.val).toFixed(1)}%"
            # else
              Math.round(Number d.data.val)
        ).style("fill", (d) -> 
            PrepareData.getColorForModes(d.data.kind)
          )

        
        alpha = 0.2
        spacing = 20

        relax = ->
          again = false
          textLabels.each (d, i) ->
            a = this
            da = d3.select(a)
            y1 = da.attr("y")
            textLabels.each (d, j) ->
              b = this
              
              # a & b are the same element and don't collide.
              return  if a is b
              db = d3.select(b)
              
              # a & b are on opposite sides of the chart and
              # don't collide
              return  unless da.attr("text-anchor") is db.attr("text-anchor")
              
              # Now let's calculate the distance between
              # these elements. 
              y2 = db.attr("y")
              deltaY = y1 - y2
              
              # Our spacing is greater than our specified spacing,
              # so they don't collide.
              return  if Math.abs(deltaY) > spacing
              
              # If the labels collide, we'll push each 
              # of the two labels up and down a little bit.
              again = true
              sign = (if deltaY > 0 then 1 else -1)
              adjust = sign * alpha
              da.attr "y", +y1 + adjust
              db.attr "y", +y2 - adjust
              return

            return

          
          # Adjust our line leaders here
          # so that they follow the labels. 
          if again
            labelElements = textLabels[0]
            textLines.attr "y2", (d, i) ->
              labelForLine = d3.select(labelElements[i])
              labelForLine.attr "y"

            setTimeout relax, 20
          return

        relax()

        if scope.legend == 'show'

          legendRectSize = 18
          legendSpacing = 4

          legend = svg.selectAll('.modes-legend')
            .data(data)
            .enter()
            .append('g')
            .attr('class', 'modes-legend')
            .attr 'transform', (d, i) ->
              offset =  width / 4 * i - width / 2
              horz = offset
              vert = height / 3 - legendRectSize
              "translate(#{horz + 20},#{vert})"

          legend.append('rect')
            .attr('width', legendRectSize)
            .attr('height', legendRectSize)
            .style('fill', (d) -> PrepareData.getColorForModes(d.kind))

          legend.append('text')
            .text (d) -> "- #{d.desc}"
            .attr("transform", "translate(#{legendRectSize * 1.5}, #{legendRectSize * 0.7})")
            .attr("dy", 0)
            .call(WrapText.wrap, 120)

    scope:
      legend: "@"
      chartData: "="
    template: "<div></div>" 
    restrict: "E"
    replace: true
    link: link
]