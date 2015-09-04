Zoomator.factory 'PrepareData', [
  "$log"
  "$filter"
  ($log, $filter)->
    new class PrepareData
      constructor: (@isPrepared = false, @total) ->
        @defaultDisplayIn = 'timeInQt'
        @modesProps = [
          {label: 'sn', desc: "работа в нормоцикле (Н)"},
          {label: 'sa', desc: "работа в ускоренном цикле (У)"},
          {label: 'sf', desc: "работа со сбоями цикла (С)"},
          {label: 'si', desc: "простой (П)"}
        ]

        @modesPropsClamps = [
          {label: 'sn_count', desc: "работа в нормоцикле (Н)"},
          {label: 'sa_count', desc: "работа в ускоренном цикле (У)"},
          {label: 'sf_count', desc: "работа со сбоями цикла (С)"},
          {label: 'si_count', desc: "простой (П)"}
        ]
        @baseProps = ["sn", "sa", "sf", "si", "sn_count", "sa_count", "sf_count", "si_count"]
        @perfProps = [
          {label: 'fact', desc: "фактически (факт)"}, 
          {label: 'pos', desc: "потери от сбоев (ПОС)"}, 
          {label: 'pop', desc: "потери от простоев (ПОП)"}
        ]
        @ctimeProps = [
          {label: 'ssn', desc: "среднее в нормоцикле (СН)"}, 
          {label: 'ssu', desc: "среднее со сбоями и ускорениями (ССУ)"}, 
          {label: 'targ', desc: "целевое (Ц)"}
        ]
        @consumpProps = [
          {label: 'cons', desc: "фактический (ФАКТ)"}
        ]

      setRawData: (rawdata) =>
        @rawdata = rawdata
        return if !rawdata.intervals || !rawdata.intervals[0]
        @total = @getTotal(@defaultDisplayIn)
        @tableData = @getTableData(@defaultDisplayIn)
        $log.info('PrepareData ready')
        @isPrepared = true

      getModesData: (displayIn) =>
        # total = @getTotal(displayIn)
        switch displayIn
          when 'timeInQt'
            _.map @modesProps, @_mapProp
          when 'cyclesInQt'
            _.map @modesPropsClamps, @_mapProp
          when 'timeInPercent'
            t = _.map @modesProps, @_mapProp
            sum = 0
            _.each t, (n) -> sum += n.val
            _.map t, (n) -> 
              n.val = n.val / sum * 100
              n
          when 'cyclesInPercent'
            t = _.map @modesPropsClamps, @_mapProp
            sum = 0
            _.each t, (n) -> sum += n.val
            _.map t, (n) -> 
              n.val = n.val / sum * 100
              n


      getPerfData: (displayIn) =>
        # {kind: "fact", val: fact, desc: "фактически (Факт)"}
        # {kind: "fail", val: failLosses, desc: "потери от сбоев (ПОС)"}
        # {kind: "idle", val: IdleLosses, desc: "потери от простоев (ПОП)"}
        _.map @perfProps, @_mapProp

      getPerfDataFull: (displayIn)=>
        _.map @tableData, (row) ->
          {
            values: [{kind: 'fact', val: row.fact}, {kind: 'pop', val: row['pop']}, {kind: 'pos', val: row.pos}],
            date: row.date
          }

      getCtimeData: ->
        # {kind: "ssn", val: averageNorm, desc: "среднее в нормоцикле (СН)"},
        # {kind: "ssu", val: averageFailAndAcl, desc: "среднее со сбоями и ускорениями (ССУ)"}
        # {kind: "targ", val: target, desc: "целевое (Ц)"}
        _.map @ctimeProps, @_mapProp

      getCtimeDataFull: (displayIn) ->
        _.map @tableData, (row) ->
          {
            values: [{kind: 'targ', val: parseFloat row.targ}, {kind: 'ssn', val: +row.ssn}, {kind: 'ssu', val: +row.ssu}],
            date: row.date
          }

      getConsumpData: ->
        _.map @consumpProps, @_mapProp

      getConsumpDataFull: ->
        _.map @tableData, (row) ->
          {
            date: row.date,
            val: row.cons
          }

      getModesDataFull: (displayIn) ->
        switch displayIn
          when 'timeInQt'
            _.map @tableData, (row) ->
              {
                sn: row.sn,
                sa: row.sa,
                si: row.si,
                sf: row.sf,
                date: row.date
              }
          when 'cyclesInQt'
            _.map @tableData, (row) ->
              {
                sn: row.sn_count,
                sa: row.sa_count,
                si: row.si_count,
                sf: row.sf_count,
                date: row.date
              }
          when 'timeInPercent'
            _.map @tableData, (row) ->
              sum = (row.sn + row.sa + row.si + row.sf) * 100
              {
                sn: row.sn / sum,
                sa: row.sa / sum,
                si: row.si / sum,
                sf: row.sf / sum,
                date: row.date
              }
          when 'cyclesInPercent'
            _.map @tableData, (row) ->
              sum = (row.sn_count + row.sa_count + row.si_count + row.sf_count) * 100
              {
                sn: row.sn_count / sum,
                sa: row.sa_count / sum,
                si: row.si_count / sum,
                sf: row.sf_count / sum,
                date: row.date
              }

      getTotal: (displayIn) =>
        if !_.isEmpty(@rawdata.intervals)
          total = _(@rawdata.intervals).reduce(((result, n)=>
                      _.each @baseProps, (prop) =>
                        if result[prop]
                          result[prop] = Math.round(result[prop] + n[prop])
                        else
                          result[prop] = Math.round(0 + n[prop])
                      result
                    ), {})
                    
          all_count = total.sn_count + total.sa_count + total.sf_count + total.si_count
          total.fact = total.sn + total.sf + total.sa + total.si
          if total.sn_count != 0 then total.ssn = Math.round total.sn / total.sn_count else total.ssn = 0
          if all_count != 0 then total.ssu = Math.round (total.fact - total.sf)/(all_count - total.si_count) else total.ssu = 0
          if total.ssn != 0 then total.pos = Math.round total.sf /total.ssn - total.sf_count else total.pos = 0
          if total.ssn != 0 then total.pop = Math.round total.si / total.ssn - total.si_count else total.pop = 0
          total.cons = total.fact * @rawdata.device.material_consumption
          total.targ = @rawdata.device.normal_cycle

          switch displayIn
            when 'timeInPercent'
              total.sn = Math.ceil(total.sn / total.fact * 100)
              total.sa = Math.ceil(total.sa / total.fact * 100)
              total.si = Math.ceil(total.si / total.fact * 100)
              total.sf = Math.ceil(total.sf / total.fact * 100)
              total.fact = 100
            when 'cyclesInPercent' 
              total.sn = Math.ceil(total.sn_count / all_count * 100)
              total.sa = Math.ceil(total.sa_count / all_count * 100)
              total.si = Math.ceil(total.si_count / all_count * 100)
              total.sf = Math.ceil(total.sf_count / all_count * 100)
              total.fact = 100
            when 'cyclesInQt'
              total.sn = Math.ceil(total.sn_count)
              total.sa = Math.ceil(total.sa_count)
              total.si = Math.ceil(total.si_count)
              total.sf = Math.ceil(total.sf_count)

          total

      getTableData: (displayIn) =>
        return {} if !@rawdata 
        tabledata = _.map @rawdata.intervals, (n) =>
          all_count = n.sn_count + n.sa_count + n.sf_count + n.si_count
          fact = n.sn + n.sf + n.sa + n.si
          if n.sn_count != 0 then ssn = n.sn / n.sn_count else ssn = 0
          if all_count == n.si_count then ssu = 0 else ssu = (fact - n.sf)/(all_count - n.si_count)
          if ssn != 0 then pos = n.sf / ssn - n.sf_count else pos = 0
          if ssn != 0 then pop = n.si / ssn - n.si_count else pop = 0
          cons = fact * @rawdata.device.material_consumption
          targ = @rawdata.device.normal_cycle
          date = Date.parse(n.dk)

          switch displayIn
            when 'timeInPercent'
              n.sn = n.sn / fact * 100
              n.sa = n.sa / fact * 100
              n.si = n.si / fact * 100
              n.sf = n.sf / fact * 100
            when 'cyclesInPercent' 
              n.sn_count = n.sn_count / all_count * 100
              n.sa_count = n.sa_count / all_count * 100
              n.si_count = n.si_count / all_count * 100
              n.sf_count = n.sf_count / all_count * 100

          result =
            date: date
            targ: targ
            cons: cons
            pop: pop
            pos: pos
            ssu: ssu
            fact: fact
            ssn: ssn
            ts: n.ts 
            sn: n.sn 
            sa: n.sa
            si: n.si 
            sf: n.sf 
            sn_count: n.sn_count
            sa_count: n.sa_count
            si_count: n.si_count
            sf_count: n.sf_count

      getColorForModes: (key) ->
        mode = @_labelFromKey(key) # amend for multiplicity of modes keys
        switch mode 
          when "norm" then "#a4dc85"
          when "fail" then "#f87e72"
          when "idle" then "#eeb679"
          when "acl" then "#a1d1f3"
          else "#eeeeee"

      getColorForPerf: (kind) ->
        switch kind
          when "fact" then "#d9a0ea"
          when "pos" then "#f87e72"
          when "pop" then "#eeb679"
          else "#eeeeee"

      getColorForCtime: (kind) ->
        switch kind
          when "ssn" then "#a4dc85"
          when "ssu" then "#a1d1f3"
          when "targ" then "#ead581"

      _labelFromKey: (key) ->
        switch
          when _.includes(['sn', 'sn_count'], key) 
            'norm'
          when _.includes(['sf', 'sf_count'], key) 
            'fail'
          when _.includes(['si', 'si_count'], key) 
            'idle'
          when _.includes(['sa', 'sa_count'], key) 
            'acl'

      _mapProp: (prop) =>
        return if !@total
        result = {}
        result.kind = prop.label
        result.val = if @total then @total[prop.label] else 0
        result.desc = prop.desc
        result
          
]
