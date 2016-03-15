DeviceNew = React.createClass
  render: ->
    React.DOM.li
      className: 'item mdl-grid'
      React.DOM.div
        className: 'mdl-cell mdl-cell--2-col'
        React.DOM.span
          className: 'device-edit-link'
          React.DOM.i
            className: 'material-icons mdl-color-text--blue-grey-100'
            'settings'
      React.DOM.div
        className: 'mdl-cell mdl-cell--10-col'
        React.DOM.h6
          className: 'device-name mdl-typography--text-uppercase'
          React.DOM.span
            className: 'mdl-color-text--blue'
            @props.device.name
        React.DOM.small
          className: 'device-online mdl-color-text--blue-grey-100'
          React.DOM.span
            className: 'label'
            'На подтверждении'
module.exports = DeviceNew
