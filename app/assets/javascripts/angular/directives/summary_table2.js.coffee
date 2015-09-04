Zoomator.directive "summaryTable2", [
  "$filter"
  "IntervalService"
  "PrepareData"
  "$rootScope"
  ($filter, IntervalService, PrepareData, $rootScope) ->

    templateUrl: "summary_table_tmpl2.html"
    restrict: "E"
    replace: true
    scope:
      modesDisplayIn: "="
      perfDisplayIn: "="
      groupBy: "="
    controller: ($scope) ->

      
      $scope.perfDisplayOptions = [
        {name: "смыкания", val: "cycles"}
        {name: "изделия", val: "products"}
      ]

      $scope.modesDisplayOptions = [
        {name: "часы, шт", val: "timeInQt"}
        {name: "часы, %", val: "timeInPercent"}
        {name: "циклы, %", val: "cyclesInPercent"}
        {name: "циклы, шт", val: "cyclesInQt"}
      ]

      $scope.groupByOptions = [
        {name: 'дни', val: 'day'},
        {name: 'недели', val: 'week'},
        {name: 'месяцы', val: 'month'}
      ]

      $scope.modesDisplayIn = $scope.modesDisplayOptions[0].val
      $scope.perfDisplayIn = $scope.perfDisplayOptions[0].val
      $scope.groupBy = $scope.groupByOptions[0].val

      $scope.$on 'loaded', ->
        $scope.tableData = PrepareData.getTableData($scope.modesDisplayIn)
        $scope.tableTotal = PrepareData.getTotal($scope.modesDisplayIn)


      $scope.$watch 'modesDisplayIn', (newval, oldval) ->
        if newval && PrepareData.isPrepared
          $scope.tableData = PrepareData.getTableData(newval)
          $scope.tableTotal = PrepareData.getTotal(newval)

      $scope.$watch 'groupBy', (newval, oldval) ->
        if newval && newval != oldval
          if newval != 'day'
            $scope.tableData = PrepareData.tableData = $filter('groupByDate')(PrepareData.getTableData(), newval)
          else
            $scope.tableData = PrepareData.tableData = PrepareData.getTableData()
          $rootScope.$broadcast('data.grouped')

      # $scope.displayIn = (kind) ->
      #   if kind.search(regexp) > 0 then true else false
]
