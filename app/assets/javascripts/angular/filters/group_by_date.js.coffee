Zoomator.filter "groupByDate", [
  "$filter"
  ($filter) ->
    (data, periodKind) ->
      ptrn = switch periodKind
        when 'week'
          'ww-yyyy'
        when 'month'
          'MM-yyyy'
      grp = _.groupBy(data, (row) => $filter('date')(row.date, ptrn))
      dates = _.keys grp
      summObjs = (arr) ->
          _.reduce(arr, ((result,obj)->
               _.each((_.keys obj), (key)->
                  result[key] += obj[key] if !_.includes(['date', 'targ'], key) 
                  result['date'] = _.first(arr).date
                  result['targ'] = _.first(arr).targ
                )
               result
            ))
      _.map dates, (date) => summObjs grp[date]
]
