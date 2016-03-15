window.moment  = require('moment-timezone')
window._  = require('underscore')
window.MicroPlugin = require('microplugin') # for selectize js
window.Sifter = require('sifter') # for selectize js
window.TimePicker = require('material-timepicker')
window.Plot = require('./constants/plot')
window.Highcharts = require('highcharts') if typeof window.Highcharts == 'undefined'
###
# Devices list
###
window.Devices = require('./components/devices')
window.Device  = require('./components/device')
window.DeviceNew  = require('./components/device_new')
###
# Device analytics
###
window.DeviceStat  = require('./components/device_stat')
window.DeviceStatExtended  = require('./components/device_stat_extended')
window.DeviceModes  = require('./components/device_stat/modes')
window.DeviceModesExtended  = require('./components/device_stat_extended/modes')
window.DevicePerfomance  = require('./components/device_stat/perfomance')
window.DevicePerfomanceExtended  = require('./components/device_stat_extended/perfomance')
window.DeviceTimes  = require('./components/device_stat/times')
window.DeviceTimesExtended  = require('./components/device_stat_extended/times')
window.DeviceMaterial  = require('./components/device_stat/material')
window.DeviceMaterialExtended  = require('./components/device_stat_extended/material')
window.DeviceSummary  = require('./components/device_stat/summary')
window.DeviceSummaryRow = require('./components/device_stat/summary_row')
###
# Device states
###
window.DeviceStates  = require('./components/states/index')
window.DeviceStatesItem  = require('./components/states/item')
