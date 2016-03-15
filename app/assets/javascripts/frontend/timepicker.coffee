$(document).on 'ready page:load', (event) ->
  if $('#datetime-picker').length > 0
    $('#datetime-picker').dateRangePicker(
      separator: ' to '
      format: 'DD-MM-YYYY'
      getValue: ->
        if ($('#start-date').val() && $('#end-date').val() )
          $('#start-date').val() + ' to ' + $('#end-date').val();
        else
          ''
      setValue: (s,s1,s2) ->
        $('#start-date').val(s1)
        $('#end-date').val(s2)
    ).bind('datepicker-change', (event,obj) ->

    ).bind 'datepicker-closed', ->
      $('#daterange-form').submit()
