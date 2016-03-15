Devices = React.createClass
  getInitialState: ->
    confirmed: []
    unconfirmed: []
  getDefaultProps: ->
    devices: []
  componentDidMount: ->
    $.get @props.source, ((result) ->
      if @isMounted()
        @setState
          confirmed: result['confirmed']
          unconfirmed: result['unconfirmed']
    ).bind(@)
  render: ->
    React.DOM.div {},
      if @state.confirmed.length > 0
        React.DOM.ul
          className: 'devices-list'
          for device in @state.confirmed
            React.createElement Device, key: device.id, device: device, uri: @props.uri, timeZone: @props.timeZone
      if @state.unconfirmed.length > 0
        React.DOM.ul
          className: 'devices-list'
          for udevice in @state.unconfirmed
            React.createElement DeviceNew, key: udevice.id, device: udevice

module.exports = Devices
