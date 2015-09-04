Zoomator.directive "consumpChart", [
  "PrepareData"
  (PrepareData) ->

    link = (scope, element, attrs) ->
      # settings
      width = angular.element(element[0]).width()
      marginTop = 40
      height = 450
      angular.element(element[0]).height(height)

      svg = d3.select(element[0])
              .append("svg")
              .style('width', width)
              .style('height', height)
              .append("g")
              .attr("transform", "translate(#{width / 2},#{height / 4 + marginTop})")

      # scope.$on "selectedPeriod:updated", () ->
      #   if PrepareData.isPrepared
      #     render PrepareData.getConsumpData()

      scope.$watch "chartData", ((newval) ->
          if newval && !_.isEmpty(newval)
            render(_.compact newval)
        ),true

      renderNoData = ->
        svg.append("text")
              .attr("class", "no-data")
              .attr("x", 0)
              .attr("y", 0)
              .attr("text-anchor", "middle")
              .text("Нет данных")

      render = (data) ->
      

        svg.selectAll('*').remove()
        return renderNoData() if !data || _.isEmpty(data)

        radius = Math.min(width, height) / 4

        circle = svg.append("circle")
                   .attr("class", "conscircle")
                   .attr("r", radius)
                   .attr("fill", "#d9a0ea")

        textWidth = null
                    
        info = svg.append("text")
                  .text(data[0].val)
                  .attr("fill", "#fff")
                  .attr("font-size", 24)
                  .attr("y", 12)
                  .each (d) ->
                    textWidth = @.getBBox().width
                  .attr("transform", "translate(-#{textWidth/2})")

    scope:
      chartData: "="
    template: "<div></div" 
    restrict: "E"
    replace: true
    link: link
]