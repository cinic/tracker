$(document).on 'ready page:load', (event) ->
  $( '.custom-select' ).selectize()
  $( '.custom-select-tickets' ).selectize(
    allowEmptyOption: true
  )
