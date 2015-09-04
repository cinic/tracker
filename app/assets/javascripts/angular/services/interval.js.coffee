Zoomator.factory 'Interval', [
  '$http', 'host', '$q',
  ($http, host, $q)->
    new class Interval

      findAll: (deviceId, start, end) ->
        
        d = $q.defer()

        try 
          s = (new Date(+start)).toISOString().slice(0, 19).replace('T', ' ')
          e = (new Date(+end)).toISOString().slice(0, 19).replace('T', ' ')

        catch error 
          console.log error

        params = {start_date: s, end_date: e}
        url = "#{host}/devices/#{deviceId}/intervals"

        $http.get(url, {params: params}).success( 
            (data)-> 
              d.resolve(data)
          )

        d.promise

      
]
