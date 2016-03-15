DevicePerfomanceExtended = React.createClass
  shouldComponentUpdate: (nextProps, nextState)->
    if nextProps.updatedState == 'perfomanceView' then true else false
  componentDidUpdate: (prevProps, prevState) ->
    $( 'select[name="perfomanceView"]' ).selectize()[0].selectize.setValue(@props.active, true)
    @props.renderChart(@props.configSum)
    @props.renderChart(@props.configExt)
    componentHandler.upgradeDom()
  componentDidMount: ->
    @props.renderChart(@props.configSum)
    @props.renderChart(@props.configExt)
    componentHandler.upgradeDom()
  _active: (name) ->
    if @props.active == name then ' is-active' else ''
  render: ->
    React.DOM.div
      className: 'mdl-tabs mdl-js-tabs mdl-js-ripple-effect'
      React.DOM.div
        className: 'mdl-tabs__tab-bar'
        React.DOM.a
          className: 'mdl-tabs__tab' + @_active('clamps')
          'data-name': 'perfomanceView'
          'data-value': 'clamps'
          onClick: @props.viewChange
          href: '#perfomance'
          I18n.t 'stats.performance.clamps'
        React.DOM.a
          className: 'mdl-tabs__tab' + @_active('items')
          'data-name': 'perfomanceView'
          'data-value': 'items'
          onClick: @props.viewChange
          href: '#perfomance'
          I18n.t 'stats.performance.items'
      React.DOM.div
        className: 'mdl-grid is-active mdl-tabs__panel device-tab-content'
        id: 'perfomance'
        React.DOM.div
          className: 'mdl-cell mdl-cell--3-col mdl-cell--12-col-tablet mdl-cell--12-col-phone'
          id: 'perfomanceGraphSum'
        React.DOM.div
          className: 'mdl-cell mdl-cell--9-col mdl-cell--12-col-tablet mdl-cell--12-col-phone'
          id: 'perfomanceGraphExt'

module.exports = DevicePerfomanceExtended
