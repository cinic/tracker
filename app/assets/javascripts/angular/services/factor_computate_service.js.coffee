Zoomator.factory "FactorComputate", [ 
  ->

    getTimelineWidth = -> angular.element('#timeline').width()

    new class FactorComputate

      getFactor: (duration) -> Math.round(duration / getTimelineWidth())

      datetimeToPosition: (startDatetime, endDatetime, markerDatetime) ->
        duration = markerDatetime - startDatetime
        allDuration = endDatetime - startDatetime
        Math.round(duration / @getFactor(allDuration))

      positionToDatetime: (startDatetime, endDatetime, position) ->
        duration = markerDatetime - startDatetime
        allDuration = endDatetime - startDatetime
        Math.round(position * @getFactor(allDuration))

]