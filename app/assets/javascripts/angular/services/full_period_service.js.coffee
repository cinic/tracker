Zoomator.factory 'FullPeriod', [
  ->
    new class FullPeriod
      constructor: ->

        @defaultStartDatetime = (+new Date) - (1000 * 60 * 60 * 24)

        @defaultEndDatetime = +new Date

        do @recalculate

      ###*
       * private
      ###

      _getFirst: ->

        if @fullIntervals
          first = _.chain @fullIntervals
                   .reject (n) -> _.isEmpty(n)
                   .map (n) -> +new Date((_.first n).time)
                   .min()
                   .value()

          if first then @startDatetime = first else @startDatetime = @defaultStartDatetime          

        else
          @startDatetime = @defaultStartDatetime

      _getLast: ->

        if @fullIntervals

          last = _.chain @fullIntervals
                  .reject (n) -> _.isEmpty(n)
                  .map (n) -> +new Date((_.last n).time)
                  .max()
                  .value()

                    
          if last && last > @defaultEndDatetime then @endDatetime = last else @endDatetime = @defaultEndDatetime

        else
          @endDatetime = @defaultEndDatetime

      ###*
       * public
      ###

      update: (fullIntervals)->
        @fullIntervals = fullIntervals
        @recalculate()

      duration: ->
        @endDatetime - @startDatetime
      

      recalculate: ->
        do @_getFirst
        do @_getLast

     
]