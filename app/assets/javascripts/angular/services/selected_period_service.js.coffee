Zoomator.factory 'SelectedPeriod', [
  "ipCookie"
  "FullPeriod"
  (ipCookie, FullPeriod) ->
    new class SelectedPeriod
      constructor: ->

        if !@startDatetime then @startDatetime = (+new Date) - (1000 * 60 * 60 * 24)
        if !@endDatetime then @endDatetime = +new Date

      ###*
       * private
      ###

      _fetchSaved: ->

        return unless ipCookie('__selectedBegin')

        return unless ipCookie('__selectedEnd')

        @startDatetime = if ipCookie('__selectedBegin') > @fullPeriodBegin
                          ipCookie('__selectedBegin')
                        else 
                          @fullPeriodBegin

        @endDatetime = if ipCookie('__selectedEnd') < @fullPeriodEnd
                        ipCookie('__selectedEnd')
                      else
                        @fullPeriodEnd

      ###*
       * public
      ###

      update: (startDatetime, endDatetime) ->
        if startDatetime > FullPeriod.startDatetime 
          @startDatetime = startDatetime
        else
          @startDatetime = FullPeriod.startDatetime

        if endDatetime < FullPeriod.endDatetime
          @endDatetime = endDatetime
        else
          @endDatetime = FullPeriod.endDatetime

      duration: ->
        @endDatetime - @startDatetime

      detail: ->
        day = 24 * 60 * 60 * 1000
        hour = 60 * 60 * 1000
        switch 
          when 180 * day < @duration() then "day"
          when 33 * day < @duration() < 180 * day then "4hour"
          when 21 * day < @duration() < 33 * day then "hour"
          when 96 * hour < @duration() < 21 * day then "30min"
          when 24 * hour < @duration() < 96 * hour then "5min"
          when 3 * hour < @duration() < 24 * hour then "1min"
          when @duration() < 3 * hour then "every"
          else "unknown detail"

      saveToCookies: ->
        ipCookie('__selectedBegin', @startDatetime, { path: '/' })
        ipCookie('__selectedEnd', @endDatetime, { path: '/' })

    
                  

]