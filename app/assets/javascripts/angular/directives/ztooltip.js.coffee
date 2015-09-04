Zoomator.directive "tip", ($compile) ->
  scope: 
    tip: "@"
  link: (scope, element, attrs) ->
    tipContent = $compile(angular.element '<div class="zoomator-tooltip">{{tip}}</div>')(scope)
    element.hover ((e)->
      # console.log e
      # set tooltip position equal to mouse pointer position
      # top = e.clientY + 20
      # left = e.clientX
      console.log element
      #set tooltip postions equal to first under element position
      top = element[0].offsetTop + 20
      left = element[0].offsetLeft 
      tipContent.css('top', top)
      element.after(tipContent)
      placed = element.parent().find('.zoomator-tooltip')[0]
      width = angular.element(placed).width()
      angular.element(placed).css('left', left - width/2)
    
      ),
      (->
        element.parent().find('.zoomator-tooltip').remove()
      )


      