DeviceSummaryRow = React.createClass
  getDefaultProps: ->
    modesTypes:
      cycles_percent: ['clamps_norm_percent', 'clamps_acl_percent', 'clamps_fail_percent', 'clamps_idle_percent']
      cycles: ['clamps_norm', 'clamps_acl', 'clamps_fail', 'clamps_idle']
      hours_percent: ['durations_norm_percent', 'durations_acl_percent', 'durations_fail_percent', 'durations_idle_percent']
      hours: ['durations_norm', 'durations_acl', 'durations_fail', 'durations_idle']
    perfomanceTypes:
      items: ['perfomance_total_items', 'perfomance_fail_items', 'perfomance_idle_items']
      clamps: ['perfomance_total_clamps', 'perfomance_fail_clamps', 'perfomance_idle_clamps']
  render: ->
    React.DOM.tr
      className: ''
      React.DOM.td
        className: 'mdl-data-table__cell--non-numeric group-date'
        @props.row.segment
      React.DOM.td
        className: 'modes-norm'
        if @props.modes == 'hours'
          @props.row[@props.modesTypes[@props.modes][0]].toString().secondsToTime()
        else if @props.modes == 'hours_percent' or @props.modes == 'cycles_percent'
          parseFloat(@props.row[@props.modesTypes[@props.modes][0]]).toFixed(1)
        else
          parseFloat(@props.row[@props.modesTypes[@props.modes][0]]).toFixed(0)
      React.DOM.td
        className: 'modes-acl'
        if @props.modes == 'hours'
          @props.row[@props.modesTypes[@props.modes][1]].toString().secondsToTime()
        else if @props.modes == 'hours_percent' or @props.modes == 'cycles_percent'
          parseFloat(@props.row[@props.modesTypes[@props.modes][1]]).toFixed(1)
        else
          parseFloat(@props.row[@props.modesTypes[@props.modes][1]]).toFixed(0)
      React.DOM.td
        className: 'modes-fail'
        if @props.modes == 'hours'
          @props.row[@props.modesTypes[@props.modes][2]].toString().secondsToTime()
        else if @props.modes == 'hours_percent' or @props.modes == 'cycles_percent'
          parseFloat(@props.row[@props.modesTypes[@props.modes][2]]).toFixed(1)
        else
          parseFloat(@props.row[@props.modesTypes[@props.modes][2]]).toFixed(0)
      React.DOM.td
        className: 'modes-idle'
        if @props.modes == 'hours'
          @props.row[@props.modesTypes[@props.modes][3]].toString().secondsToTime()
        else if @props.modes == 'hours_percent' or @props.modes == 'cycles_percent'
          parseFloat(@props.row[@props.modesTypes[@props.modes][3]]).toFixed(1)
        else
          parseFloat(@props.row[@props.modesTypes[@props.modes][3]]).toFixed(0)
      React.DOM.td
        className: 'perfomance'
        parseFloat(@props.row[@props.perfomanceTypes[@props.perfomance][0]]).toFixed(0)
      React.DOM.td
        className: 'perfomance-fail'
        parseFloat(@props.row[@props.perfomanceTypes[@props.perfomance][1]]).toFixed(0)
      React.DOM.td
        className: 'perfomance-idle'
        parseFloat(@props.row[@props.perfomanceTypes[@props.perfomance][2]]).toFixed(0)
      React.DOM.td
        className: 'time-norm'
        parseFloat(@props.row.times_norm).toFixed(2)
      React.DOM.td
        className: 'time-all'
        parseFloat(@props.row.times_all).toFixed(2)
      React.DOM.td
        className: 'time-goal'
        parseFloat(@props.row.times_goal).toFixed(2)
      React.DOM.td
        className: 'material'
        parseFloat(@props.row.material_consumption).toFixed(3)

module.exports = DeviceSummaryRow
