Zoomator.directive 'localeDropdown', ($document, $window) ->
  {
    scope: 
      availableValues: '='
      current: '@'
    template: '<div class="smart-dropdown lang-{{selectedValue.name}}" >{{selectedValue.name}}' + '<ul class="dropdown">' + '<li ng-repeat="val in variants track by $index" ng-click="selectValue(val)"><a class="lang-{{val.name}}">{{val.name}}</a></li>' + '</ul>' + '</div>'
    restrict: 'EA'
    replace: true
    controller: ($scope) ->

      $scope.selectedValue = _.find $scope.availableValues, (v) -> v.url == $scope.current

      fetchRuPathname = (pathname) -> 
        pathname.replace('/en', '')

      $scope.selectValue = (v) ->
        $scope.selectedValue = v
        initVariants()
        pathname =  $window.location.pathname
        

        $window.location.href = if $scope.selectedValue.url == 'ru' then fetchRuPathname(pathname) else $scope.selectedValue.url + pathname

      initVariants = ->          
        $scope.variants = _.clone $scope.availableValues 
        _.remove $scope.variants, (v) -> v.name == $scope.selectedValue.name


      initVariants()

    link: (scope, element, attribute) ->
      dd = element[0]
      angular.element(dd).on 'click', (event) ->
        $(@).toggleClass 'active'
        event.stopPropagation()
      $document.on 'click', ->
        $(dd).removeClass 'active'

  }
