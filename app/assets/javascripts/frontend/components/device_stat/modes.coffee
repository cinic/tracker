DeviceModes = React.createClass
  shouldComponentUpdate: (nextProps, nextState)->
    if nextProps.updatedState == 'modesView' then true else false
  componentDidUpdate: (prevProps, prevState) ->
    $( 'select' ).selectize()[0].selectize.setValue(@props.active, true)
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
          I18n.t 'stats.modes.title'
          React.DOM.a
            className: 'link-to-extended'
            href: @props.extUri
            I18n.t 'stats.more'
        React.DOM.div
          className: 'mdl-tabs mdl-js-tabs mdl-js-ripple-effect'
          React.DOM.div
            className: 'mdl-tabs__tab-bar'
            React.DOM.a
              className: 'mdl-tabs__tab' + @_active('cycles')
              'data-name': 'modesView'
              'data-value': 'cycles'
              'data-graph': 'modes'
              onClick: @props.viewChange
              href: '#modesGraph'
              I18n.t 'stats.modes.cycles'
            React.DOM.a
              className: 'mdl-tabs__tab' + @_active('cycles_percent')
              'data-name': 'modesView'
              'data-value': 'cycles_percent'
              'data-graph': 'modes'
              onClick: @props.viewChange
              href: '#modesGraph'
              I18n.t 'stats.modes.cycles_percent'
            React.DOM.a
              className: 'mdl-tabs__tab' + @_active('hours')
              'data-name': 'modesView'
              'data-value': 'hours'
              'data-graph': 'modes'
              onClick: @props.viewChange
              href: '#modesGraph'
              I18n.t 'stats.modes.hours'
            React.DOM.a
              className: 'mdl-tabs__tab' + @_active('hours_percent')
              'data-name': 'modesView'
              'data-value': 'hours_percent'
              'data-graph': 'modes'
              onClick: @props.viewChange
              href: '#modesGraph'
              I18n.t 'stats.modes.hours_percent'
          React.DOM.div
            className: 'mdl-tabs__panel is-active'
            id: 'modesGraph'

module.exports = DeviceModes
