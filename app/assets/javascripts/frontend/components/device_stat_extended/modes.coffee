DeviceModesExtended = React.createClass
  shouldComponentUpdate: (nextProps, nextState)->
    if nextProps.updatedState == 'modesView' then true else false
  componentDidUpdate: (prevProps, prevState) ->
    $( 'select[name="modesView"]' ).selectize()[0].selectize.setValue(@props.active, true)
    @props.renderChart(@props.configPie)
    @props.renderChart(@props.configArea)
    componentHandler.upgradeDom()
  componentDidMount: ->
    @props.renderChart(@props.configPie)
    @props.renderChart(@props.configArea)
    componentHandler.upgradeDom()
  _active: (name) ->
    if @props.active == name then ' is-active' else ''
  render: ->
    React.DOM.div
      className: 'mdl-tabs mdl-js-tabs mdl-js-ripple-effect'
      React.DOM.div
        className: 'mdl-tabs__tab-bar'
        React.DOM.a
          className: 'mdl-tabs__tab' + @_active('cycles')
          'data-name': 'modesView'
          'data-value': 'cycles'
          onClick: @props.viewChange
          href: '#modes'
          I18n.t 'stats.modes.cycles'
        React.DOM.a
          className: 'mdl-tabs__tab' + @_active('cycles_percent')
          'data-name': 'modesView'
          'data-value': 'cycles_percent'
          onClick: @props.viewChange
          href: '#modes'
          I18n.t 'stats.modes.cycles_percent'
        React.DOM.a
          className: 'mdl-tabs__tab' + @_active('hours')
          'data-name': 'modesView'
          'data-value': 'hours'
          onClick: @props.viewChange
          href: '#modes'
          I18n.t 'stats.modes.hours'
        React.DOM.a
          className: 'mdl-tabs__tab' + @_active('hours_percent')
          'data-name': 'modesView'
          'data-value': 'hours_percent'
          onClick: @props.viewChange
          href: '#modes'
          I18n.t 'stats.modes.hours_percent'
      React.DOM.div
        className: 'mdl-grid is-active mdl-tabs__panel device-tab-content'
        id: 'modes'
        React.DOM.div
          className: 'mdl-cell mdl-cell--3-col mdl-cell--12-col-tablet mdl-cell--12-col-phone'
          id: 'modesGraphPie'
        React.DOM.div
          className: 'mdl-cell mdl-cell--9-col mdl-cell--12-col-tablet mdl-cell--12-col-phone'
          id: 'modesGraphArea'

module.exports = DeviceModesExtended
