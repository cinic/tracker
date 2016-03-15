DeviceStates = React.createClass
  propTypes:
    data: React.PropTypes.array.isRequired
  render: ->
    React.DOM.div
      className: 'mdl-grid'
      React.DOM.div
        className: 'mdl-cell mdl-cell--12-col'
        React.DOM.h2 {}, 'История состояний трекера'
        React.DOM.div
          className: 'table-responsive'
          React.DOM.table
            className: 'table mdl-data-table mdl-shadow--2dp states-table'
            React.DOM.thead {},
              React.DOM.tr {},
                React.DOM.th
                  className: 'mdl-data-table__cell--non-numeric'
                  'Время сеанса связи'
                React.DOM.th {}, 'Температура'
                React.DOM.th {}, 'Аккумулятор'
                React.DOM.th {}, 'Координаты'
            _.map @props.data, (state) ->
              React.createElement DeviceStatesItem, key: "state-#{state.id}", state: state

module.exports = DeviceStates
