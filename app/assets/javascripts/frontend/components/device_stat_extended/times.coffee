DeviceTimesExtended = React.createClass
  shouldComponentUpdate: (nextProps, nextState)->
    false
  componentDidMount: ->
    @props.renderChart(@props.configSum)
    @props.renderChart(@props.configExt)
  render: ->
    React.DOM.div
      className: 'mdl-cell mdl-cell--12-col mdl-grid'
      React.DOM.div
        className: 'mdl-cell mdl-cell--3-col mdl-cell--12-col-tablet mdl-cell--12-col-phone'
        id: 'timesGraphSum'
      React.DOM.div
        className: 'mdl-cell mdl-cell--9-col mdl-cell--12-col-tablet mdl-cell--12-col-phone'
        id: 'timesGraphExt'

module.exports = DeviceTimesExtended
