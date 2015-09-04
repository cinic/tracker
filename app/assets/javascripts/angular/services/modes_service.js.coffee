Zoomator.factory "Modes", [ "$http", "$q", "$filter", 
  ($http, $q, $filter) ->

    # ========================================================
    # collection of functions around recieved device modes
    # ========================================================

    new class Modes

      sumNorm: (data) ->
        _.reduce data, ((sum, n) ->
          sum + Number(n.norm)
          ), 0
        
      sumFail: (data) ->
        _.reduce data, ((sum, n) ->
          sum + Number(n.fail)
          ), 0

      sumIdle: (data) ->
        _.reduce data, ((sum, n) ->
          sum + Number(n.idle)
          ), 0

      sumAcl: (data) ->
        _.reduce data, ((sum, n) -> 
          sum + Number(n.acl)
          ), 0

      timeNorm: (data) ->
        _.reduce data, ((sum, n) ->
          sum + ( + new Date Number(n.duration_norm) )
          ), 0

      timeFail: (data) ->
        _.reduce data, ((sum, n) ->
          sum + ( + new Date Number(n.duration_fail) )
          ), 0

      timeIdle: (data) ->
        _.reduce data, ((sum, n) ->
          sum + ( + new Date Number(n.duration_idle) )
          ), 0

      timeAcl: (data) ->
        _.reduce data, ((sum, n) -> 
          sum + ( + new Date Number(n.duration_acl) )
          ), 0

      

]