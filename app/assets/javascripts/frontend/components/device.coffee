Device = React.createClass
  render: ->
    React.DOM.li
      className: 'item mdl-grid'
      React.DOM.div
        className: 'mdl-cell mdl-cell--2-col'
        React.DOM.a
          className: 'device-edit-link'
          href: @props.uri + '/' + @props.device.id + '/edit'
          React.DOM.i
            className: 'material-icons'
            'settings'
        # React.DOM.div
          # className: 'device-battery'
          # @props.device.state.v_batt if @props.device.state
      React.DOM.div
        className: 'mdl-cell mdl-cell--10-col'
        React.DOM.h6
          className: 'device-name mdl-typography--text-uppercase'
          React.DOM.a
            className: 'mdl-color-text--blue'
            href: @props.uri + '/' + @props.device.id
            @props.device.name
        # React.DOM.div
          # className: 'device-type mdl-color-text--blue-grey-100'
          # React.DOM.small
            # className: 'label'
            # 'Тип: '
          # React.DOM.small
            # className: 'type'
            # @props.device.device_type
        React.DOM.small
          className: 'device-online mdl-color-text--blue-grey-100'
          React.DOM.span
            className: 'label'
            'Данные получены: '
          if @props.device.state
            React.DOM.time
              className: 'datetime'
              dateTime: @props.device.state.datetime
              # Add .utc() before .format to change timezone to UTC
              moment.tz(@props.device.state.datetime, @props.timeZone).format('DD.MM.YYYY [в] H:mm')
module.exports = Device
