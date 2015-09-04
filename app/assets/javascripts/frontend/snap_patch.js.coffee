###*
 * Snap svg plugins
###

Snap.plugin (Snap, Element) ->
  Element::moveTo = (x,y) ->
    diffx = @getBBox().cx - x
    diffy = @getBBox().cy - y
    @attr("transform", @transform().local + "#{if @transform().local then 'T' else 't'}#{-diffx},#{-diffy}")


  Element::getCursorPoint = (x, y) ->
    pt = @paper.node.createSVGPoint()
    pt.x = x
    pt.y = y
    pt.matrixTransform @paper.node.getScreenCTM().inverse()

  Element::getCenter = ->
    brect = @node.getBoundingClientRect()
    parseInt(brect.left + brect.width/2)