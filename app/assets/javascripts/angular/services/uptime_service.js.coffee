Zoomator.factory "Uptime", ($http, host)->
  new class Uptime
    getForDevice: (deviceId) ->
      url = "#{host}/devices/#{deviceId}/uptime"
      $http.get(url)
