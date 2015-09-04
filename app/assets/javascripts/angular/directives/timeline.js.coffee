Zoomator.directive "timeline", [
  "$filter"
  "$document"
  "$window"
  "FactorComputate"
  ($filter, $document, $window, FactorComputate) ->

    restrict: "EA"
    replace: true
    templateUrl: "timeline.html"
    scope:
      selectedPeriodBegin: "="
      selectedPeriodEnd: "="
      fullPeriodBegin: "="
      fullPeriodEnd: "="
      iconsPath: "@"
      markerDatetime: "="
      markerPosition: "="


    link: (scope, element) ->
     
      ###*
       * timeline main class
      ###
      containerWidth = angular.element("#timeline").width()
      containerHeight = angular.element("#timeline").height()

      class Timeline
        constructor: (@containerWidth, @containerHeight) ->
          @paper = Snap angular.element('#timeline').find('svg')[0]
          @paper.selectAll('*').remove()

          ###*
           * initialize timeline components
          ###

          # @iconNames = ['to_left', 'to_right', 'drag_left', 'drag_right', 'runner']

          Snap.load scope.iconsPath, (icons) =>
            @svgIcons = icons
            @topAxis = new TopAxis(@)
            @bottomAxis = new BottomAxis(@)
            @selector = new Selector(@)

            scope.markerDatetime = scope.selectedPeriodBegin + (scope.selectedPeriodEnd - scope.selectedPeriodBegin) / 2
            scope.markerPosition = @bottomAxis.timestampToXPosition(scope.markerDatetime)


            @marker = new Marker(@)

            scope.$emit('timeline:ready')

        ###*
         * public
        ###

        update: ->
          if @topAxis

            newx1 = @topAxis.timestampToXPosition(scope.selectedPeriodBegin)
            newx2 = @topAxis.timestampToXPosition(scope.selectedPeriodEnd)

            @selector.update(newx1, newx2)

            @bottomAxis.updateLabels()

            scope.$emit('timeline:ready')


      class TopAxis
        constructor: (@timeline) ->
          @paper = @timeline.paper
          @duration = scope.fullPeriodEnd - scope.fullPeriodBegin
          @nodeClass = "t_axis"
          @strokeWidth = 2
          @margin = 
            left: 25
            right: 25
            top: 20
          @labels = []
          @minLabelsSpacing = 4
          @bigLabelsNumber = 10
          @length = @timeline.containerWidth - @margin.left - @margin.right
          @labelsNumber = Math.ceil(@length / @minLabelsSpacing)
          @bigLabelsSpacing = Math.ceil(@labelsNumber / @bigLabelsNumber)
          @pixelMilliseconds =  @duration / @length

          do @_fillLabels

          do @_draw

          do @_drawSideControls


        _drawSideControls: ->
         
          moversGroup = @paper.group().attr(class: 'movers')

          @lm = @timeline.svgIcons.select "#to_left"

          @paper.append @lm

          moversGroup.g @lm
                     .attr(class: 'move-left').moveTo(0 + @lm.getBBox().width/2, @margin.top*3/4)
                     .click(@_leftShiftPeriod)

          @rm = @timeline.svgIcons.select "#to_right"
          @paper.append @rm

          moversGroup.g @rm
                     .attr(class: 'move-right').moveTo(@length - @rm.getBBox().width/2 + @margin.right*2, @margin.top*3/4)      
                     .click(@_rightShiftPeriod)

        _leftShiftPeriod: ->
          duration = scope.selectedPeriodEnd - scope.selectedPeriodBegin
          if scope.selectedPeriodBegin - duration > scope.fullPeriodBegin
            scope.selectedPeriodEnd -= duration
            scope.selectedPeriodBegin -= duration
            

        _rightShiftPeriod: ->
          duration = scope.selectedPeriodEnd - scope.selectedPeriodBegin
          if scope.selectedPeriodEnd + duration < scope.fullPeriodEnd
            scope.selectedPeriodEnd += duration
            scope.selectedPeriodBegin += duration

        _fillLabels: ->
          _.times @labelsNumber, (n) =>
            type = switch
              when n % @bigLabelsSpacing == 0 && n != 0 && n != @labelsNumber
                "big"
              when n % 2 == 0
                "medium"
              else 
                "small"

            x = n*@minLabelsSpacing + @margin.left
           
            label = new Label(@, x, type)
          

            @labels.push label if label != undefined

          @labels = _.compact @labels

        _draw: ->
          @tAxis = @paper.g(@paper.line(@margin.left, @margin.top, @timeline.containerWidth - @margin.right, @margin.top)
                                  .attr({class: "#{@nodeClass}"})).attr(class: 'topaxis-group')

          _.each @labels, (l) => l.draw(@tAxis)

        ###*
         * Public
        ###

        xPositionToTimestamp: (x) ->
          scope.fullPeriodBegin + @pixelMilliseconds * (x - @margin.left)

        timestampToXPosition: (ts) ->
          @margin.left + (ts - scope.fullPeriodBegin) / @pixelMilliseconds



      class BottomAxis
        constructor: (@timeline) ->
          @paper = @timeline.paper
          @duration = scope.selectedPeriodEnd - scope.selectedPeriodBegin
          @nodeClass = "b_axis"
          @strokeWidth = 4
          @margin = 
            top: @timeline.containerHeight
            left: 0
            right: 0
         
          @labels = []
          @minLabelsSpacing = 4
          @bigLabelsNumber = 10
          @length = @timeline.containerWidth
          @labelsNumber = Math.ceil(@length / @minLabelsSpacing)
          @bigLabelsSpacing = Math.ceil(@labelsNumber / @bigLabelsNumber)
          @pixelMilliseconds =  @duration / @length

          do @_fillLabels

          do @_draw


        _fillLabels: ->
          _.times @labelsNumber, (n) =>
            type = switch
              when n % @bigLabelsSpacing == 0 && n != 0 && n != @labelsNumber
                "big"
              when n % 2 == 0
                "medium"
              else 
                "small"
            
            x = n*@minLabelsSpacing
           
            label = new Label(@, x, type)
          

            @labels.push label if label != undefined

          @labels = _.compact @labels

        _draw: ->
          @tAxis = @paper.g(@paper.line(@margin.left, @margin.top, @timeline.containerWidth - @margin.right, @margin.top)
                                  .attr({class: "#{@nodeClass}"})).attr(class: 'bottomaxis-group')

          _.each @labels, (l) => l.draw(@tAxis)


        _refreshCoeffs: =>
          @duration = scope.selectedPeriodEnd - scope.selectedPeriodBegin
          @pixelMilliseconds =  @duration / @length

        ###*
         * Public
        ###

        xPositionToTimestamp: (x) ->
          scope.selectedPeriodBegin + @pixelMilliseconds * x

        timestampToXPosition: (ts) ->
          (ts - scope.selectedPeriodBegin) / @pixelMilliseconds 

        updateLabels: =>
          do @_refreshCoeffs

          bigLabels = _.filter @labels,  (label) -> label.type == 'big'
          _.each bigLabels, (label) =>
            ts = @xPositionToTimestamp(label.x)
            d = "#{$filter('date')(ts, 'dd MMMM yyyy')}"
            t = "#{$filter('date')(ts, 'HH:MM')}"
            label.updateText(d,t)
          
      
      class Label 
        constructor: (@axis, @x, @type) ->
          @nodeClass = switch
            when @axis instanceof TopAxis then "t_mark"
            when @axis instanceof BottomAxis then "b_mark"

          @bigLabelClass = switch
            when @axis instanceof TopAxis then "axis_labels"
            when @axis instanceof BottomAxis then "bt_axis_labels"
             
          @bigTopLabelTextBottomOffset = 2
          @bigBottomLabelBottomDateOffset = 12
          @bigBottomLabelBottomTimeOffset = 2
          @labelHeight = switch @type
            when "big" then 8
            when "medium" then 4
            when "small" then 2
          @text = @axis.xPositionToTimestamp(@x)


        ###*
         * public
        ###

        draw: (g) =>
          if @type != "big"
            g.add(@axis.paper.line(@x, @axis.margin.top - @axis.strokeWidth/2, @x, @axis.margin.top - @labelHeight - @axis.strokeWidth/2).attr({class: "#{@nodeClass} #{@type}"}))
          else
            @bigLabelGroup = @axis.paper.g(
                                            @axis.paper.line(@x, @axis.margin.top - @axis.strokeWidth/2, @x, @axis.margin.top - @labelHeight - @axis.strokeWidth/2).attr({class: "#{@nodeClass} #{@type}"})
                                          ).attr(class: 'big-labels-group')
            

            if @axis instanceof TopAxis
              @bigLabelGroup.add(@axis.paper.text(@x, @axis.margin.top - @labelHeight - @bigTopLabelTextBottomOffset - @axis.strokeWidth, ["#{$filter('date')(@text, 'dd MMMM yyyy')}"])
                                         .attr({class: "#{@bigLabelClass}", textAnchor: 'middle' }))
            else
              @dateText = @axis.paper.text(@x, @axis.margin.top - @labelHeight - @bigBottomLabelBottomDateOffset - @axis.strokeWidth, ["#{$filter('date')(@text, 'dd MMMM yyyy')}"])
                                         .attr({class: "#{@bigLabelClass}", textAnchor: 'middle' })

              @bigLabelGroup.add(@dateText)


              @timeText = @axis.paper.text(@x, @axis.margin.top - @labelHeight - @bigBottomLabelBottomTimeOffset - @axis.strokeWidth, ["#{$filter('date')(@text, 'HH:MM')}"])
                                         .attr({class: "#{@bigLabelClass}", textAnchor: 'middle' })

              @bigLabelGroup.add(@timeText)

            g.add @bigLabelGroup


        updateText: (d, t) =>
          @dateText.node.textContent = d
          @timeText.node.textContent = t


      class Selector 
        constructor: (@timeline) ->

          @paper = @timeline.paper
          @begin = @timeline.topAxis.timestampToXPosition(scope.selectedPeriodBegin)
          @end = @timeline.topAxis.timestampToXPosition(scope.selectedPeriodEnd)
          @runnerWidth = 10
          do @_draw

        _draw: ->
         
          @line = @paper.line  @begin, 20,  @end, 20
                .attr {class: "range_selector", stroke: "#76b7e4", strokeWidth: 10}
                .drag(@move, @startMove, @endMove)

          @tlBorder = @paper.line(0, @timeline.containerHeight - 60, @begin, @timeline.containerHeight - 60)
                            .attr(class: 'tl_border')


          @trBorder = @paper.line(@end, @timeline.containerHeight - 60, @timeline.containerWidth, @timeline.containerHeight - 60)
                            .attr(class: 'tr_border')

          @paper.g( @paper.line(0, @timeline.containerHeight - 60, 0, @timeline.containerHeight).attr({class: 'r_border'}),
                    @paper.line(@timeline.containerWidth, @timeline.containerHeight - 60, @timeline.containerWidth, @timeline.containerHeight).attr({class: 'l_border'}) )
        
          
          @rightRunner = @timeline.svgIcons.select "#drag_right"
          @paper.append @rightRunner
          @rightRunner.moveTo(@end + @rightRunner.getBBox().width/2, @timeline.topAxis.margin.top + 2)
                      .drag(@rightRunnerMove, @rightRunnerMoveStart, @rightRunnerMoveEnd)


          @leftRunner = @timeline.svgIcons.select "#drag_left"
          @paper.append @leftRunner
          @leftRunner.moveTo(@begin - @leftRunner.getBBox().width/2, @timeline.topAxis.margin.top + 2)
                     .drag(@leftRunnerMove, @leftRunnerMoveStart, @leftRunnerMoveEnd)

          @controlGroup = @timeline.topAxis.tAxis.add(
                                    @line,
                                    @leftRunner,
                                    @rightRunner
                                  ).attr(class: 'control-group')

        update: (newx1, newx2) ->
          @begin = newx1
          @end = newx2
          
          @leftRunner.moveTo(newx1 - @leftRunner.getBBox().width / 2, @leftRunner.getBBox().cy)
          @rightRunner.moveTo(newx2 + @rightRunner.getBBox().width / 2, @rightRunner.getBBox().cy)
          @line.attr('x1', newx1)
          @line.attr('x2', newx2)
          @tlBorder.attr('x2', newx1)
          @trBorder.attr('x1', newx2)
          


        move: (dx) =>
          @updateMovement(@line, dx)

        startMove: (x) =>
          @saveOrigData()

        endMove: (e) =>
          ex1 = @line.attr("x1")
          ex2 = @line.attr("x2")
          scope.selectedPeriodBegin = @timeline.topAxis.xPositionToTimestamp(ex1)
          scope.selectedPeriodEnd = @timeline.topAxis.xPositionToTimestamp(ex2)

        leftRunnerMove: (dx) =>
          @updateMovement(@leftRunner, dx)
          
        leftRunnerMoveStart: (x) =>
          @saveOrigData()

        leftRunnerMoveEnd: (e) =>
          ex1 = @line.attr("x1")
          scope.selectedPeriodBegin = @timeline.topAxis.xPositionToTimestamp(ex1)
          scope.$apply()
          

        rightRunnerMove: (dx) =>
          @updateMovement(@rightRunner, dx)

        rightRunnerMoveStart: (x) =>
          @saveOrigData()

        rightRunnerMoveEnd: (e) =>
          ex2 = @line.attr("x2")
          scope.selectedPeriodEnd = @timeline.topAxis.xPositionToTimestamp(ex2)
          scope.$apply()

        saveOrigData: =>
          @line.data 'ox1', @line.attr("x1")
          @line.data 'ox2', @line.attr("x2")
          @leftRunner.data 'origTransform', @leftRunner.transform().local
          @rightRunner.data 'origTransform', @rightRunner.transform().local
          @leftRunner.data "origBBoxCx", @leftRunner.getBBox().cx
          @rightRunner.data "origBBoxCx", @rightRunner.getBBox().cx
          @leftRunner.data 'ibb', @leftRunner.getBBox()
          @rightRunner.data 'ibb', @rightRunner.getBBox()

        updateMovement: (obj, dx) =>
          unless obj == @line
            @translateRunner(obj,dx)
          newx1 = +@line.data("ox1") + dx
          newx2 = +@line.data("ox2") + dx
          switch  
            when obj == @leftRunner
              lim1 = @timeline.topAxis.margin.left
              lim2 =  @line.attr('x2')
              if newx1 < lim1
                @line.attr('x1', lim1)
                @tlBorder.attr('x2', lim1)
              else if newx1 > lim2
                @line.attr('x1', lim2)
                @tlBorder.attr('x2', lim2)
              else
                @line.attr('x1', newx1)
                @tlBorder.attr('x2', newx1)

            when obj == @rightRunner
              lim1 = @line.attr('x1')
              lim2 = @timeline.containerWidth - @timeline.topAxis.margin.right
              if newx2 < lim1
                @line.attr('x2', lim1)
                @trBorder.attr('x1', lim1)
              else if newx2 > lim2
                @line.attr('x2', lim2)
                @trBorder.attr('x1', lim2)
              else
                @line.attr('x2', newx2)
                @trBorder.attr('x1', newx2)
            when obj == @line
              lim1 = 0 + @timeline.topAxis.margin.left
              lim2 = @timeline.containerWidth - @timeline.topAxis.margin.right
              if newx1 > lim1 && newx2 < lim2
                newx1 = +@line.data("ox1") + dx
                newx2 = +@line.data("ox2") + dx
                @line.attr('x1', newx1)
                @line.attr('x2', newx2)
                @trBorder.attr('x1', newx2)
                @tlBorder.attr('x2', newx1)
                _.each [@leftRunner, @rightRunner], (ele) =>
                  @translateRunner(ele,dx)

        translateRunner: (ele, dx) =>
          if ele == @leftRunner
            lim1 = @rightRunner.getBBox().x
            lim2 = @timeline.topAxis.margin.left
            cur = @leftRunner.data("ibb").x2 + dx
            if cur > lim1
              dx = lim1 - @leftRunner.data("ibb").x2
            if cur < lim2
              dx = lim2 - @leftRunner.data("ibb").x2
          else if ele == @rightRunner 
            lim1 = @leftRunner.getBBox().cx + @leftRunner.getBBox().width/2
            lim2 = @timeline.containerWidth - @timeline.topAxis.margin.right
            cur = @rightRunner.data("ibb").x + dx
            if cur < lim1
              dx = lim1 - @rightRunner.data("ibb").x
            if cur > lim2
              dx = lim2 - @rightRunner.data("ibb").x

          transformString = ele.data('origTransform') + "#{if ele.data('origTransform') then 'T' else 't'}#{dx}"
          ele.attr 'transform', transformString


      class Marker
        constructor: (@timeline)->
          @paper = @timeline.paper
          @icon = @timeline.svgIcons.select '#runner'
          @position =  @timeline.containerWidth / 2 || @timeline.bottomAxis.timestampToXPosition(scope.markerDatetime)
          @lim1 = 0
          @lim2 = @timeline.containerWidth



          do @_draw

          do @_bindEvents

          do @_setStartPosition


        ###*
         * private
        ###

        _setStartPosition: =>
          scope.markerPosition = @icon.getCenter()
          scope.$apply()

        _draw: ->
          @paper.append @icon
          shiftx = @icon.getBBox().height/2
          @icon.moveTo @position, @timeline.containerHeight - shiftx - 2

        _bindEvents: ->
          @icon.drag(@_onMove, @_onStartMove, @_onEndMove)

        _onMove: (dx) =>
          cx = @icon.data("startcx")
          if  cx + dx < @lim1
            dx = @lim1 - cx
          else if @icon.data("startcx") + dx > @lim2
            dx = @lim2 - cx

          @icon.attr("transform", @icon.data('origTransform') + "#{if @icon.data('origTransform') then 'T' else 't'}#{dx}")
          
          acx = @icon.getCenter()


          scope.markerDatetime = Math.round (@timeline.bottomAxis.xPositionToTimestamp(cx + dx))
          scope.markerPosition = acx
          console.log('markerPosition', scope.markerPosition)

          scope.$apply()

        _onStartMove: ->
          @data('origTransform', @transform().local)
          @data('startcx', @getBBox().cx)


        _onEndMove:=>
          console.log "end move"

        _getCenterx: ->
          @centerx = 0

      tl = undefined


      scope.$watchGroup ["fullPeriodBegin","fullPeriodEnd"], (newvalues) ->
        if newvalues[0] && newvalues[1]
          tl = new Timeline(angular.element("#timeline").width(), angular.element("#timeline").height())
          console.log('timeline: full period changed!', angular.element("#timeline").width(), angular.element("#timeline").height())

      scope.$watchGroup ["selectedPeriodBegin","selectedPeriodEnd"], (newvalues, oldvalues) ->
        if newvalues[0] && newvalues[1]
          tl.update()
          console.log('timeline: selected period changed!')
         
  ]
   
