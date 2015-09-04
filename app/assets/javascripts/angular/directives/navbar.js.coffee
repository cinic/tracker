Zoomator.directive "navbar", [
  () ->

    scope:
      activeItem: "@"
    templateUrl: "navbar_tmpl.html"
    restrict: "E"
    replace: true
    controller: ($scope) ->

      getActiveIndex = (i,n) ->
        found = null
        _.each i, (x, index) ->
          found = index if x.actionName == n
        found


      $scope.items = [
        { name: "Мониторинг", url: "/devices", actionName: "index" },
        { name: "О сервисе", url: "/pages/about", actionName: "about" },
        { name: "Купить", url: "/pages/buy", actionName: "buy" },
        { name: "Поддержка", url: "/pages/support", actionName: "support" }
      ]

      $scope.activeIndex = getActiveIndex($scope.items, $scope.activeItem)

      

]