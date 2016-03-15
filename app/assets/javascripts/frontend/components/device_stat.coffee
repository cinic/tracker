DeviceStat = React.createClass
  propTypes:
    data: React.PropTypes.array.isRequired
  getInitialState: ->
    updated: false
    modesView: 'cycles'
    perfomanceView: 'clamps'
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
      React.createElement DeviceModes, key: 'deviceModes', viewChange: @viewChange, renderChart: Plot.renderChart, config: Plot.prepareConfig('modes', 'pie', 'modesGraph', @state.modesView, @props.data), updatedState: @state.updated, active: @state.modesView, extUri: @props.uris.modes
      React.createElement DevicePerfomance, key: 'devicePerfomance', viewChange: @viewChange, renderChart: Plot.renderChart, config: Plot.prepareConfig('perfomance', 'column', 'perfomanceGraph', @state.perfomanceView, @props.data), updatedState: @state.updated, active: @state.perfomanceView, extUri: @props.uris.perfomance
      React.createElement DeviceTimes, key: 'deviceTimes', viewChange: @viewChange, renderChart: Plot.renderChart, config: Plot.prepareConfig('times', 'column', 'timesGraph', null, @props.data), extUri: @props.uris.times
      React.createElement DeviceMaterial, key: 'deviceMaterial', viewChange: @viewChange, renderChart: Plot.renderChart, config: Plot.prepareConfig('material', 'pie', 'materialGraph', null, @props.data), extUri: @props.uris.material
      React.DOM.div
        className: 'mdl-cell mdl-cell--12-col mdl-shadow--2dp'
        React.DOM.div
          className: 'table-responsive'
          React.createElement DeviceSummary, key: 'deviceSummary', viewChange: @viewChange, rows: @props.data, modes: @state.modesView, perfomance: @state.perfomanceView

module.exports = DeviceStat
