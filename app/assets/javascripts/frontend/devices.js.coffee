$ ->
  $("#deviceStates").find('tr.active').on 'click', ->
    $(".yamap").toggle()
  $(".hide-map").on "click", ->
    $(".yamap").hide()

  $(".legend").on "click", ->
    $('.legend').toggleClass("l-hidden")

$(window).scroll (event) ->
  scroll = $(window).scrollTop()
  if scroll > 300
    $('.scrollnav').slideDown("fast")
  else
    $('.scrollnav').slideUp("fast")

@WidthChange = (mq) ->
  if mq.matches
    $('.fix350').addClass("max350")


if matchMedia
  mq = window.matchMedia("(min-width: 1350px)")
  mq.addListener WidthChange
  WidthChange mq


