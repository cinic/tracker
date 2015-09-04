Zoomator.service 'IntervalService', [  

  class IntervalService

    # ========================================================
    # collection of functions around recieved device intervals
    # ========================================================

    # choose the color of interval on chart to the respective mode of device work type

    colorForMode: (type) ->
      switch type
        when "acl" then "#a1d1f3"
        when "norm" then "#a4dc85"
        when "idle" then "#eeb679"
        when "fail" then "#f87e72"
        else "#ffffff"

    # find first date for all intervals collections

    findLastDate: (intervalsCls) ->

      withIntervals = _.reject intervalsCls, (n) ->
        _.isEmpty(n)

      compared = _.map withIntervals, (n) ->
        +new Date((_.last n).time)

      max = _.max compared

      if max > +new Date
        return max
      else
        return +new Date


    # find first date for all intervals collections

    findFirstDate: (intervalsCls) ->

      withIntervals = _.reject intervalsCls, (n) ->
        _.isEmpty(n)

      compared = _.map withIntervals, (n) ->
        +new Date((_.first n).time)

      _.min compared


    # calculate the displacement along the x axis for each interval

    addXShift: (a, selectedPeriod) ->

      if !_.isEmpty(a)

        firstLocalShift = (+new Date(a[0].datetime)) - selectedPeriod.startDatetime

        lastLocalShift = selectedPeriod.endDatetime - (+new Date(a[a.length - 1].datetime))

        firstLocalShift = 0 if firstLocalShift < 0

        lastLocalShift = 0 if lastLocalShift < 0
        

        newA = _.map a, (n, index) ->

          if index != 0

            durations = _.first a, index

            x = _.chain durations
                    .pluck "width"
                    .reduce (sum, num) ->
                      sum + num

                    .value()

            x += firstLocalShift

          else

            x = firstLocalShift

          { x: x, width: n.width, color: n.color, datetime: n.datetime, mode: n.mode }

        newA.unshift( { x: 0, width: firstLocalShift, color: "nodata", datetime: selectedPeriod.startDatetime, mode: "none" } )

        if 0 < lastLocalShift

          newA[newA.length - 1].color = "nodata"

        newA

      else

        [ { x: 0, width: selectedPeriod.endDatetime - selectedPeriod.startDatetime, color: "nodata", datetime: selectedPeriod.startDatetime, mode: "none" } ]


      


    # prepare raw API data for chart dataset

    fetchDataset: (a, selectedPeriod) ->

      # to do:  move calculate and insert no data intervals into this func from addXShift 

      ary = _.map a, (n, index) =>
        if index != a.length - 1
          duration = (+new Date a[index + 1]["time"]) - (+new Date n["time"])
        else
          if selectedPeriod.endDatetime == +new Date n.time
            duration = (+new Date) - (+new Date n.time)
          else
            duration = (selectedPeriod.endDatetime) - (+new Date n.time)

        { width: duration, color: @colorForMode(n.type), datetime: n.time, mode: n.type }

      @addXShift(ary, selectedPeriod)


    detectIntervalType: (deviceModes) ->
      
      intervalDuration = ( +new Date deviceModes[2].time ) -  ( +new Date deviceModes[1].time )

      day = 24 * 60 * 60 * 1000

      switch 
        when intervalDuration < 4 * 60 * 1000 then "hours"
        when 4 * 60 * 1000 <= intervalDuration < day then "4hours"
        when day <= intervalDuration < day * 7 then "days"
        when day * 7 <= intervalDuration < day * 29 then "weeks"
        when day * 29 <= intervalDuration < day * 364 then "months"
        when day * 32 <= intervalDuration  then "years"

    getPermittedGroupModesByOptions: (currentInterval) ->

      allOptions = [
        {name: "Часы", val: "hours"}
        {name: "4 часа", val: "4hours"}
        {name: "Дни", val: "days"}
        {name: "Недели", val: "weeks"}
        {name: "Месяцы", val: "months"}
        {name: "Года", val: "years"}
      ]

      indexOfSame = 0

      _.each allOptions, (o, i) ->
        if o.val == currentInterval
          indexOfSame = i

      result = _.filter allOptions, (option, index) ->
        index >= indexOfSame


      result



  ]