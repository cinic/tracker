Zoomator.factory "Clamp", [
  "$http", "$filter", "$q", "host", 
  ($http, $filter, $q, host) ->
    new class Clamp

      findAll: (deviceId, start, end) ->


        if !deviceId 
          throw "device id undefined"
      
        d = $q.defer()
        try 
          s = (new Date(+start)).toISOString().slice(0, 19).replace('T', ' ')
          e = (new Date(+end)).toISOString().slice(0, 19).replace('T', ' ')
        catch error 
          console.log error

        url = "#{host}/devices/#{deviceId}/clamps"
        params = {start_date: s, end_date: e}
       
        $http.get(url, {params: params}).success( 
            (data)-> 
              d.resolve(data)
          )

        d.promise
]