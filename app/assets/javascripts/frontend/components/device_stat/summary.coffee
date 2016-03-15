DeviceSummary = React.createClass
  componentDidMount: ->
    $( 'select' ).selectize(
      highlight: false
      create: false
      hideSelected: true
      closeAfterSelect: true
      allowEmptyOption: false
    ).on( 'change', @props.viewChange)
  render: ->
    React.DOM.table
      className: 'mdl-data-table summary-table'
      React.DOM.thead {},
        React.DOM.tr {},
          React.DOM.th
            className: 'mdl-data-table__cell--non-numeric group-date bordered top'
            rowSpan: '2'
            I18n.t 'stats.summary.group'
          React.DOM.th
            className: 'top'
            colSpan: '4'
            I18n.t 'stats.modes.title'
            React.DOM.select
              name: 'modesView'
              value: @props.modes
              onChange: @props.viewChange
              React.DOM.option
                value: 'cycles'
                I18n.t 'stats.modes.cycles'
              React.DOM.option
                value: 'cycles_percent'
                I18n.t 'stats.modes.cycles_percent'
              React.DOM.option
                value: 'hours'
                I18n.t 'stats.modes.hours'
              React.DOM.option
                value: 'hours_percent'
                I18n.t 'stats.modes.hours_percent'
          React.DOM.th
            className: 'top'
            colSpan: '3'
            I18n.t 'stats.performance.title'
            React.DOM.select
              name: 'perfomanceView'
              value: @props.perfomance
              onChange: @props.viewChange
              React.DOM.option
                value: 'clamps'
                I18n.t 'stats.performance.clamps'
              React.DOM.option
                value: 'items'
                I18n.t 'stats.performance.items'
          React.DOM.th
            className: 'top'
            colSpan: '3'
            I18n.t 'stats.times.title'
          React.DOM.th
            className: 'top'
            I18n.t 'stats.material_consumption.title'
        React.DOM.tr {},
          React.DOM.th
            className: 'modes-norm bordered'
            'Н'
          React.DOM.th
            className: 'modes-acl bordered'
            'У'
          React.DOM.th
            className: 'modes-fail bordered'
            'С'
          React.DOM.th
            className: 'modes-idle bordered'
            'П'
          React.DOM.th
            className: 'perfomance bordered'
            'ФАКТ'
          React.DOM.th
            className: 'perfomance-fail bordered'
            'ПОС'
          React.DOM.th
            className: 'perfomance-idle bordered'
            'ПОП'
          React.DOM.th
            className: 'time-norm bordered'
            'СН'
          React.DOM.th
            className: 'time-all bordered'
            'ССУ'
          React.DOM.th
            className: 'time-goal bordered'
            'Ц'
          React.DOM.th
            className: 'material bordered'
            'ФАКТ'
      React.DOM.tbody {},
        if typeof @props.rows == 'object' && @props.rows.length > 1
          @props.rows.map ((row, i) ->
            React.createElement DeviceSummaryRow, key: i, row: row, modes: @props.modes, perfomance: @props.perfomance
          ), @
        else
          React.DOM.tr
            className: ''
            React.DOM.td
              className: 'mdl-data-table__cell--non-numeric'
              colSpan: '12'
              @props.rows[0]

module.exports = DeviceSummary
