Zoomator.factory "Dataset", ->
  class Dataset 
    constructor: (first, last, @intervals) ->

      @offset = first

      if @intervals && !_.isEmpty(@intervals) 

        @first = 
          fromTs: first
          toTs: +new Date(@intervals[0].time)
          width: (+new Date(@intervals[0].time)) - first
          type: "nodata"
          fromX: 0
          toX: (+new Date(@intervals[0].time)) - @offset
          color: "nodata"

        @last = 
          fromTs: +new Date(_.last(@intervals).time)
          toTs: last
          width: (last - +new Date(_.last(@intervals).time))
          type: "nodata"
          fromX: +new Date(_.last(@intervals).time) - @offset
          toX: last - @offset
          color: "nodata"

        prepdata = do @_prepData

        @data = [@first].concat(prepdata)

      else

        @first = @last = 
          fromTs: first
          toTs: last
          width: last - first
          type: "nodata"
          fromX: 0
          toX: last - @offset
          color: "nodata"

        @data = [@first]

    _prepData: =>
      
      _.map @intervals, (interval, i) =>

        if i != @intervals.length - 1

          from = +new Date(interval.time)
          to = +new Date((@intervals[i+1]).time)
          type = interval.type
          color = @_colorForMode(type)


          result = 
            fromTs: from
            toTs: to
            width: to - from
            type: type
            fromX: from - @offset
            toX: to - @offset
            color: color

        else

          result = @last

        result

    _colorForMode: (type) ->
      switch type
        when "acl" then "#a1d1f3"
        when "norm" then "#a4dc85"
        when "idle" then "#eeb679"
        when "fail" then "#f87e72"
        else "nodata"