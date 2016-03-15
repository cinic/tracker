Plot =
  colors:
    acl: '#a1d1f3'
    fail: '#f87e72'
    idle: '#eeb679'
    norm: '#a4dc85'
    total: '#d9a0ea'
    all: '#9c6876'
    goal: '#ead581'
  config:
    credits:
      enabled: false
    chart:
      plotBackgroundColor: 'white'
      plotBorderWidth: 0
      plotShadow: false
    title: text: ''
    subtitle: text: ''
    tooltip:
      pointFormat: '<b>{point.y}</b>'
    plotOptions:
      pie:
        allowPointSelect: true
        cursor: 'pointer'
        dataLabels:
          enabled: false
        showInLegend: true
      areaspline:
        fillOpacity: 0.4,
        marker:
          enabled: false
          symbol: 'circle'
        lineWidth: 1
  renderChart: (config) ->
    if !config
      throw new Error('Config must be specified for the modesChart component')
    @chart = new (Highcharts['chart'])(config)
  prepareConfig: (name, type, to, view, arr) ->
    if arr.length > 1
      data = arr[0]
      series = @prepareSeries(data, name, view)
    if type == 'pie'
      chartData =
        series: [{ data: series }]
        legend:
          labelFormatter: ->
            switch view
              when 'cycles' then '<b>' + @name + ' - ' + @y + '</b>'
              when 'hours' then '<b>' + @name + ' - ' + (@y).toString().secondsToTime() + '</b>'
              when 'cycles_percent', 'hours_percent' then '<b>' + @name + ' - ' + (@y).toFixed(4) + '</b>'
              else '<b>' + @name + ' - ' + @y + '</b>'
        tooltip:
          formatter: ->
            switch view
              when 'cycles' then '<b>' + @y + '</b>'
              when 'hours' then '<b>' + (@y).toString().secondsToTime() + '</b>'
              when 'cycles_percent', 'hours_percent' then '<b>' + (@y).toFixed(4) + '</b>'
              else '<b>' + @y + '</b>'
    else if type == 'column'
      chartData =
        xAxis: type: 'category'
        plotOptions: series: dataLabels: enabled: true
        tooltip:
          formatter: ->
            switch view
              when 'clamps' then '<b>' + (@y).toFixed(0) + '</b>'
              when 'items' then '<b>' + (@y).toFixed(0) + '</b>'
              else '<b>' + @y + '</b>'
        legend: enabled: false
        series: [data: series]
    else if type == 'column2'
      chartData =
        xAxis:
          type: 'datetime'
          dateTimeLabelFormats:
            month: '%e. %b'
            year: '%b'
          title: text: ''
        yAxis:
          title: text: ''
          min: 0
        tooltip:
          headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
          pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td><td style="padding:0"><b>{point.y:.1f}</b></td></tr>',
          footerFormat: '</table>'
          shared: true
          useHTML: true
        legend: enabled: false
        plotOptions:
          column:
            pointPadding: switch name
              when 'material' then 0.1
              else -0.5
            borderWidth: 0
        series: switch name
          when 'perfomance' then @preparePerfomance(arr, view)
          when 'times' then @prepareTimes(arr)
          when 'material' then @prepareMaterial(arr)
      type = 'column'
    else if type == 'areaspline'
      chartData =
        xAxis:
          type: 'datetime'
          dateTimeLabelFormats:
            month: '%e. %b'
            year: '%b'
          title: text: ''
        yAxis:
          title: text: ''
          min: 0
        tooltip:
          shared: true
          headerFormat: '<b>{series.name}</b><br>'
          pointFormat: '{point.x:%e. %b}: {point.y:.2f} m'
        series: @prepareAreaSpline(arr, view)
    config = _.extend({}, @config, { chart: _.extend({}, @config.chart, { type: type, renderTo: to }) }, chartData)
  prepareSeries: (data, type, view) ->
    series = []
    if type == 'modes' && view == 'cycles_percent'
      series = [{
          name: I18n.t 'stats.modes.norm'
          y: parseFloat data['clamps_norm_percent']
          color: @colors.norm
        },{
          name: I18n.t 'stats.modes.acl'
          y: parseFloat data['clamps_acl_percent']
          color: @colors.acl
        },{
          name: I18n.t 'stats.modes.fail'
          y: parseFloat data['clamps_fail_percent']
          color: @colors.fail
        },{
          name: I18n.t 'stats.modes.idle'
          y: parseFloat data['clamps_idle_percent']
          color: @colors.idle
      }]
    else if type == 'modes' && view == 'cycles'
      series = [{
          name: I18n.t 'stats.modes.norm'
          y: parseFloat data['clamps_norm']
          color: @colors.norm
        },{
          name: I18n.t 'stats.modes.acl'
          y: parseFloat data['clamps_acl']
          color: @colors.acl
        },{
          name: I18n.t 'stats.modes.fail'
          y: parseFloat data['clamps_fail']
          color: @colors.fail
        },{
          name: I18n.t 'stats.modes.idle'
          y: parseFloat data['clamps_idle']
          color: @colors.idle
      }]
    else if type == 'modes' && view == 'hours_percent'
      series = [{
          name: I18n.t 'stats.modes.norm'
          y: parseFloat data['durations_norm_percent']
          color: @colors.norm
        },{
          name: I18n.t 'stats.modes.acl'
          y: parseFloat data['durations_acl_percent']
          color: @colors.acl
        },{
          name: I18n.t 'stats.modes.fail'
          y: parseFloat data['durations_fail_percent']
          color: @colors.fail
        },{
          name: I18n.t 'stats.modes.idle'
          y: parseFloat data['durations_idle_percent']
          color: @colors.idle
      }]
    else if type == 'modes' && view == 'hours'
      series = [{
          name: I18n.t 'stats.modes.norm'
          y: parseFloat data['durations_norm']
          color: @colors.norm
        },{
          name: I18n.t 'stats.modes.acl'
          y: parseFloat data['durations_acl']
          color: @colors.acl
        },{
          name: I18n.t 'stats.modes.fail'
          y: parseFloat data['durations_fail']
          color: @colors.fail
        },{
          name: I18n.t 'stats.modes.idle'
          y: parseFloat data['durations_idle']
          color: @colors.idle
      }]
    else if type == 'perfomance' && view == 'items'
      series = [{
          name: I18n.t 'stats.performance.actual'
          y: parseFloat data['perfomance_total_items']
          color: @colors.total
        },{
          name: I18n.t 'stats.performance.fail'
          y: parseFloat data['perfomance_fail_items']
          color: @colors.fail
        },{
          name: I18n.t 'stats.performance.idle'
          y: parseFloat data['perfomance_idle_items']
          color: @colors.idle
        }]
    else if type == 'perfomance' && view == 'clamps'
      series = [{
          name: I18n.t 'stats.performance.actual'
          y: parseFloat data['perfomance_total_clamps']
          color: @colors.total
        },{
          name: I18n.t 'stats.performance.fail'
          y: parseFloat data['perfomance_fail_clamps']
          color: @colors.fail
        },{
          name: I18n.t 'stats.performance.idle'
          y: parseFloat data['perfomance_idle_clamps']
          color: @colors.idle
        }]
    else if type == 'times'
      series = [{
          name: I18n.t 'stats.times.norm'
          y: parseFloat data['times_norm']
          color: @colors.norm
        },{
          name: I18n.t 'stats.times.acl_fail'
          y: parseFloat data['times_all']
          color: @colors.all
        },{
          name: I18n.t 'stats.times.goal'
          y: parseFloat data['times_goal']
          color: @colors.goal
        }]
    else if type == 'material'
      series = [{
          name: I18n.t 'stats.material_consumption.actual'
          y: parseFloat data['material_consumption']
          color: @colors.total
        }]
  prepareAreaSpline: (data, view) ->
    # Prepare series for extended modes view
    arr = data.slice 0
    arr.shift()
    arr.reverse()
    series = [
      {
        name: I18n.t 'stats.modes.norm'
        data: []
        color: @colors.norm
      }, {
        name: I18n.t 'stats.modes.acl'
        data: []
        color: @colors.acl
      }, {
        name: I18n.t 'stats.modes.fail'
        data: []
        color: @colors.fail
      }, {
        name: I18n.t 'stats.modes.idle'
        data: []
        color: @colors.idle
      }
    ]
    if view == 'cycles_percent'
      _.map arr, (item) ->
        series[0]['data'].push([Date.parse(item['segment']), parseFloat(item['clamps_norm_percent'])])
        series[1]['data'].push([Date.parse(item['segment']), parseFloat(item['clamps_acl_percent'])])
        series[2]['data'].push([Date.parse(item['segment']), parseFloat(item['clamps_fail_percent'])])
        series[3]['data'].push([Date.parse(item['segment']), parseFloat(item['clamps_idle_percent'])])
    else if view == 'cycles'
      _.map arr, (item) ->
        series[0]['data'].push([Date.parse(item['segment']), parseFloat(item['clamps_norm'])])
        series[1]['data'].push([Date.parse(item['segment']), parseFloat(item['clamps_acl'])])
        series[2]['data'].push([Date.parse(item['segment']), parseFloat(item['clamps_fail'])])
        series[3]['data'].push([Date.parse(item['segment']), parseFloat(item['clamps_idle'])])
    else if view == 'hours_percent'
      _.map arr, (item) ->
        series[0]['data'].push([Date.parse(item['segment']), parseFloat(item['durations_norm_percent'])])
        series[1]['data'].push([Date.parse(item['segment']), parseFloat(item['durations_acl_percent'])])
        series[2]['data'].push([Date.parse(item['segment']), parseFloat(item['durations_fail_percent'])])
        series[3]['data'].push([Date.parse(item['segment']), parseFloat(item['durations_idle_percent'])])
    else if view == 'hours'
      _.map arr, (item) ->
        series[0]['data'].push([Date.parse(item['segment']), parseFloat((item['durations_norm'] / 3600).toFixed(4))])
        series[1]['data'].push([Date.parse(item['segment']), parseFloat((item['durations_acl'] / 3600).toFixed(4))])
        series[2]['data'].push([Date.parse(item['segment']), parseFloat((item['durations_fail'] / 3600).toFixed(4))])
        series[3]['data'].push([Date.parse(item['segment']), parseFloat((item['durations_idle'] / 3600).toFixed(4))])
    series
  preparePerfomance: (data, view) ->
    # Prepare series for extended modes view
    arr = data.slice 0
    arr.shift()
    arr.reverse()
    series = [
      {
        name: I18n.t 'stats.performance.actual'
        data: []
        color: @colors.total
      }, {
        name: I18n.t 'stats.performance.fail'
        data: []
        color: @colors.fail
      }, {
        name: I18n.t 'stats.performance.idle'
        data: []
        color: @colors.idle
      }
    ]
    if view == 'items'
      _.map arr, (item) ->
        series[0]['data'].push([Date.parse(item['segment']), parseFloat(item['perfomance_total_items'])])
        series[1]['data'].push([Date.parse(item['segment']), parseFloat(item['perfomance_fail_items'])])
        series[2]['data'].push([Date.parse(item['segment']), parseFloat(item['perfomance_idle_items'])])
    else if view == 'clamps'
      _.map arr, (item) ->
        series[0]['data'].push([Date.parse(item['segment']), parseFloat(item['perfomance_total_clamps'])])
        series[1]['data'].push([Date.parse(item['segment']), parseFloat(item['perfomance_fail_clamps'])])
        series[2]['data'].push([Date.parse(item['segment']), parseFloat(item['perfomance_idle_clamps'])])
    series
  prepareTimes: (data, view) ->
    # Prepare series for extended modes view
    arr = data.slice 0
    arr.shift()
    arr.reverse()
    series = [
      {
        name: I18n.t 'stats.times.norm'
        data: []
        color: @colors.norm
      }, {
        name: I18n.t 'stats.times.acl_fail'
        data: []
        color: @colors.all
      }, {
        name: I18n.t 'stats.times.goal'
        data: []
        color: @colors.goal
      }
    ]
    _.map arr, (item) ->
      series[0]['data'].push([Date.parse(item['segment']), parseFloat(item['times_norm'])])
      series[1]['data'].push([Date.parse(item['segment']), parseFloat(item['times_all'])])
      series[2]['data'].push([Date.parse(item['segment']), parseFloat(item['times_goal'])])
    series
  prepareMaterial: (data, view) ->
    # Prepare series for extended modes view
    arr = data.slice 0
    arr.shift()
    arr.reverse()
    series = [
      {
        name: I18n.t 'stats.material_consumption.actual'
        data: []
        color: @colors.total
      }
    ]
    _.map arr, (item) ->
      series[0]['data'].push([Date.parse(item['segment']), parseFloat(item['material_consumption'])])
    series

module.exports = Plot
