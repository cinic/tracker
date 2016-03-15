DeviceMaterial = React.createClass
  shouldComponentUpdate: (nextProps, nextState) ->
    false
  componentDidMount: ->
    @props.renderChart(@props.config)
  render: ->
    React.DOM.div
      className: 'mdl-shadow--2dp mdl-color--white mdl-cell mdl-cell--6-col mdl-cell--12-col-tablet mdl-cell--12-col-phone mdl-grid'
      React.DOM.div
        className: 'mdl-cell mdl-cell--12-col'
        React.DOM.h5
          className: 'mdl-layout-title mdl-color-text--blue-grey-700 mdl-typography--font-light'
          I18n.t 'stats.material_consumption.title'
          #React.DOM.small
            #className: 'mdl-color-text--grey-500'
            #'кг'
          React.DOM.a
            className: 'link-to-extended'
            href: @props.extUri
            I18n.t 'stats.more'
        React.DOM.div
          id: 'materialGraph'

module.exports = DeviceMaterial
