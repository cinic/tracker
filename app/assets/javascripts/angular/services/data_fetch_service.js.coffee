Zoomator.factory "DataFetch", [
  ->
    new class DataFetch

      fetchModesDataset: (dataset, scope) ->

        if scope.calculateModesIn == "cyclesQt"

          result_norm = scope.sumNorm
          result_fail = scope.sumFail
          result_idle = scope.sumIdle
          result_acl  = scope.sumAcl

        else if scope.calculateModesIn == "cyclesPerc" 

          result_norm = scope.sumNorm / scope.sumAll * 100
          result_fail = scope.sumFail / scope.sumAll * 100
          result_idle = scope.sumIdle / scope.sumAll * 100
          result_acl  = scope.sumAcl  / scope.sumAll * 100

        else if scope.calculateModesIn == "timePerc" 

          result_norm = scope.timeNorm / scope.timeAll * 100
          result_fail = scope.timeFail / scope.timeAll * 100
          result_idle = scope.timeIdle / scope.timeAll * 100
          result_acl  = scope.timeAcl  / scope.timeAll * 100

        else if scope.calculateModesIn == "timeQt" 

          result_norm = scope.timeNorm / (60 * 60)
          result_fail = scope.timeFail / (60 * 60)
          result_idle = scope.timeIdle / (60 * 60)
          result_acl  = scope.timeAcl  / (60 * 60)

        dMax = switch scope.calculateModesIn
          when "cyclesQt" then scope.sumAll
          when "timeQt" then scope.timeAll / (60 * 60)
          else 100

        getLabelType = (x, max) ->
          if x >= max / 10
            "norm"
          else
            "small"

        [
          {mode: "norm", val: result_norm, desc: "работа в нормоцикле (Н)", ltype: getLabelType(result_norm, dMax)}
          {mode: "fail", val: result_fail, desc: "работа со сбоями (С)", ltype: getLabelType(result_fail, dMax)}
          {mode: "idle", val: result_idle, desc: "простой (П)", ltype: getLabelType(result_idle, dMax)}
          {mode: "acl",  val: result_acl,  desc: "работа в ускоренном цикле (У)", ltype: getLabelType(result_acl, dMax)}
        ]  

]