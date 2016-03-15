# Convert number of seconds into time object
# @param integer secs Number of seconds to convert
# @return object

String.prototype.secondsToTime = ->
  secs = parseInt @, 10
  hours = Math.floor(secs / (60 * 60))

  divisor_for_minutes = secs % (60 * 60)
  minutes = Math.floor(divisor_for_minutes / 60)

  divisor_for_seconds = divisor_for_minutes % 60
  seconds = Math.ceil(divisor_for_seconds)

  hours = '0' + hours if hours < 10
  minutes = '0' + minutes if minutes < 10
  seconds = '0' + seconds if seconds < 10

  hours + 'ч ' + minutes + 'м ' + seconds + 'с'
