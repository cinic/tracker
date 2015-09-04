Zoomator.factory "Device", [ "$http", "$q", "$filter", "host"
  ($http, $q, $filter, host) ->

    # ========================================================
    # exchange data with API
    # ========================================================

    new class Device

      getAllClamps: (deviceId, startDate, endDate) ->
        $http({
                method: 'GET',
                url: "/api/v2/devices/#{deviceId}/clamps",
                params: {
                          start_date: startDate,
                          end_date: endDate
                        }
              })


      updateDevice: (device) ->

        deferred = $q.defer()

        $http({
            method: "PUT",
            url: "/devices/#{device.id}"
            data: device
          })
          .success (response) ->
            deferred.resolve(response)
          .error (error) ->
            deferred.reject(error)

        deferred.promise


     


      addDevice: (deviceData) ->

        deferred = $q.defer()

        $http({
            method: "POST",
            url: "/devices"
            data: deviceData
          })
          .success (response) ->
            deferred.resolve(response)
          .error (error) ->
            deferred.reject(error)

        deferred.promise


      getFullDeviceIntervals: (id) ->

        deferred = $q.defer()

        $http({
            method: "GET",
            url: "/api/v1/devices/#{id}/graph.json"
          })
          .success (response) ->
            deferred.resolve(response)
          .error (error) ->
            deferred.reject(error)

        deferred.promise


      getDeviceIntervals: (id, startDate, endDate) ->


        startDate = $filter('date')(startDate, 'yyyy-MM-dd HH:mm')
        endDate = $filter('date')(endDate, 'yyyy-MM-dd HH:mm')


        deferred = $q.defer()

        $http({
            method: "GET",
            url: "/api/v1/devices/#{id}/graph.json",
            params: {start_date: startDate, end_date: endDate}
          })
          .success (response) ->
            deferred.resolve(response)
          .error (error) ->
            deferred.reject(error)

        deferred.promise

      getDevices: ->
        url = "#{host}/devices";
        $http({ method: "GET", url: url })

      getDevice: (id) ->

        deferred = $q.defer()

        $http({ method: "GET", url: "/api/v1/devices/#{id}/settings.json" })
          .success (response) ->
            deferred.resolve(response)

        deferred.promise

      getDeviceModes: (id, startDate, endDate) ->

        startDate = $filter('date')(startDate, 'yyyy-MM-dd HH:mm')
        endDate = $filter('date')(endDate, 'yyyy-MM-dd HH:mm')

        deferred = $q.defer()

        $http({
            method: "GET",
            url: "/api/v1/devices/#{id}/modes.json",
            params: {start_date: startDate, end_date: endDate}
          })
          .success (response) ->
            deferred.resolve(response)

        deferred.promise



      getDeviceStates: (id) ->

        deferred = $q.defer()

        $http({
            method: "GET",
            url: "/api/v1/devices/#{id}/states.json"
          })
          .success (response) ->
            deferred.resolve(response)

        deferred.promise

      createNew: (device) ->
        url = "/devices"
        $http.post(url, {device: device})


]
