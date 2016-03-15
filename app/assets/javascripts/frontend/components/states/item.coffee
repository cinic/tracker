DeviceStatesItem = React.createClass
  propTypes:
    state: React.PropTypes.object.isRequired
  getInitialState: ->
    mapVisible: 'hidden'
  handleClick: (e) ->
    e.preventDefault()
    elem = e.target
    mapId = elem.dataset.ymap
    container = elem.dataset.container
    gis = elem.dataset.gis.split(',')
    $(container).slideToggle 500, ->
      placemark = new ymaps.Placemark(if gis then [gis[0],gis[1]] else [55.76, 37.64])
      map = new ymaps.Map mapId,
        center: if gis then [gis[0],gis[1]] else [55.76, 37.64]
        zoom: 14
      map.geoObjects.add placemark
  render: ->
    React.DOM.tbody {},
      React.DOM.tr {},
        React.DOM.td
          className: 'mdl-data-table__cell--non-numeric'
          moment.tz(@props.state.datetime, 'Europe/Moscow').format('HH:mm:ss DD.MM.YYYY')
        React.DOM.td {},
          @props.state.temp
        React.DOM.td {},
          @props.state.v_batt
        React.DOM.td {},
          React.DOM.a
            className: 'open-map-link'
            href: "#tr-map-#{@props.state.id}"
            'data-ymap': "map-#{@props.state.id}"
            'data-container': "#tr-map-#{@props.state.id}"
            'data-gis': @props.state.gis
            onClick: @handleClick
            @props.state.gis
      React.DOM.tr
        className: 'hidden-row ymap-container'
        id: "tr-map-#{@props.state.id}"
        React.DOM.td
          className: 'mdl-data-table__cell--non-numeric'
          colSpan: '5'
          React.DOM.div
            className: 'state-ymap'
            id: "map-#{@props.state.id}"

module.exports = DeviceStatesItem
