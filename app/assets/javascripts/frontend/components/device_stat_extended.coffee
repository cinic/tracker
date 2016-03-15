DeviceStatExtended = React.createClass
  propTypes:
    data: React.PropTypes.array.isRequired
    view: React.PropTypes.string.isRequired
  getInitialState: ->
    updated: false
    modesView: 'cycles_percent'
    perfomanceView: 'items'
  getDefaultProps: ->
    data: []
  viewChange: (e) ->
    switch e.target.localName
      when 'select' then name = e.target.name; value = e.target.value
      else name = e.target.offsetParent.dataset.name; value = e.target.offsetParent.dataset.value
    @setState "#{ name }": value
    @setState updated: name
  render: ->
    React.DOM.div
      className: 'mdl-grid'
      if @props.view == 'modes'
        React.DOM.div
          className: 'mdl-shadow--2dp mdl-cell mdl-cell--12-col mdl-color--white'
          React.createElement DeviceModesExtended,
            key: 'DeviceModesExtended'
            viewChange: @viewChange
            renderChart: Plot.renderChart
            configPie: Plot.prepareConfig('modes', 'pie', 'modesGraphPie', @state.modesView, @props.data)
            configArea: Plot.prepareConfig('modes', 'areaspline', 'modesGraphArea', @state.modesView, @props.data)
            active: @state.modesView
            updatedState: @state.updated
      else if @props.view == 'perfomance'
        React.createElement DevicePerfomanceExtended,
          key: 'devicePerfomanceExtended'
          viewChange: @viewChange
          renderChart: Plot.renderChart
          configSum: Plot.prepareConfig('perfomance', 'column', 'perfomanceGraphSum', @state.perfomanceView, @props.data)
          configExt: Plot.prepareConfig('perfomance', 'column2', 'perfomanceGraphExt', @state.perfomanceView, @props.data)
          updatedState: @state.updated
          active: @state.perfomanceView
      else if @props.view == 'times'
        React.createElement DeviceTimesExtended,
          key: 'deviceTimesExtended'
          viewChange: @viewChange
          renderChart: Plot.renderChart
          configSum: Plot.prepareConfig('times', 'column', 'timesGraphSum', 'times', @props.data)
          configExt: Plot.prepareConfig('times', 'column2', 'timesGraphExt', 'times', @props.data)
      else if @props.view == 'material'
        React.createElement DeviceMaterialExtended,
          key: 'deviceMaterialExtended'
          viewChange: @viewChange
          renderChart: Plot.renderChart
          configSum: Plot.prepareConfig('material', 'column', 'materialGraphSum', null, @props.data)
          configExt: Plot.prepareConfig('material', 'column2', 'materialGraphExt', null, @props.data)
      React.DOM.div
        className: 'mdl-cell mdl-cell--12-col mdl-shadow--2dp'
        React.DOM.div
          className: 'table-responsive'
          React.createElement DeviceSummary, key: 'deviceSummary', viewChange: @viewChange, rows: @props.data, modes: @state.modesView, perfomance: @state.perfomanceView
      #React.createElement DeviceTimes, key: 'deviceTimes', viewChange: @viewChange, renderChart: Plot.renderChart, config: Plot.prepareConfig('times', 'column', 'timesGraph', null, @props.data)
      #React.createElement DeviceMaterial, key: 'deviceMaterial', viewChange: @viewChange, renderChart: Plot.renderChart, config: Plot.prepareConfig('material', 'pie', 'materialGraph', null, @props.data)

module.exports = DeviceStatExtended
