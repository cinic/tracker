Zoomator.filter 'gisConvert', ["$sce", 

  ($sce) ->

    (data) ->

      getGisArray = (data) ->
        data.split(",")

      getDegrees = (data) ->
        data.split(".")[0]

      getMs = (data) ->
        result = []
        result.push data.split(".")[1].split("")[0]
        result.push data.split(".")[1].split("")[1]
        result.join("")

      getSs = (data) ->
        result = []
        result.push data.split(".")[1].split("")[2]
        result.push data.split(".")[1].split("")[3]
        result.join("")

      gisFormat = (data) ->
        gis = getGisArray(data)
        lng = "#{getDegrees(gis[0])}&deg; #{getMs(gis[0])}\' #{getSs(gis[0])}\""
        lat = "#{getDegrees(gis[1])}&deg; #{getMs(gis[1])}\' #{getSs(gis[1])}\""
        $sce.trustAsHtml "#{lng} с.ш. #{lat} в.д."

      gisFormat(data)

]



