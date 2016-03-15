DevicePerfomance = React.createClass
  shouldComponentUpdate: (nextProps, nextState)->
    if nextProps.updatedState == 'perfomanceView' then true else false
  componentDidUpdate: ->
    $( 'select' ).selectize()[1].selectize.setValue(@props.active, true)
    @props.renderChart(@props.config)
    componentHandler.upgradeDom()
  componentDidMount: ->
    @props.renderChart(@props.config)
    componentHandler.upgradeDom()
  _active: (name) ->
    if @props.active == name then ' is-active' else ''
  render: ->
    React.DOM.div
      className: 'mdl-shadow--2dp mdl-color--white mdl-cell mdl-cell--6-col mdl-cell--12-col-tablet mdl-cell--12-col-phone mdl-grid'
      React.DOM.div
        className: 'mdl-cell mdl-cell--12-col'
        React.DOM.h5
          className: 'mdl-layout-title mdl-color-text--blue-grey-700 mdl-typography--font-light'
          I18n.t 'stats.performance.title'
          React.DOM.a
            className: 'link-to-extended'
            href: @props.extUri
            I18n.t 'stats.more'
        React.DOM.div
          className: 'mdl-tabs mdl-js-tabs mdl-js-ripple-effect'
          React.DOM.div
            className: 'mdl-tabs__tab-bar'
            React.DOM.a
              className: 'mdl-tabs__tab' + @_active('clamps')
              'data-name': 'perfomanceView'
              'data-value': 'clamps'
              onClick: @props.viewChange
              href: '#perfomanceGraph'
              I18n.t 'stats.performance.clamps'
            React.DOM.a
              className: 'mdl-tabs__tab' + @_active('items')
              'data-name': 'perfomanceView'
              'data-value': 'items'
              onClick: @props.viewChange
              href: '#perfomanceGraph'
              I18n.t 'stats.performance.items'
          React.DOM.div
            className: 'mdl-tabs__panel is-active'
            id: 'perfomanceGraph'

module.exports = DevicePerfomance
