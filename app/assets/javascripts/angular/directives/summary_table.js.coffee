Zoomator.directive "summaryTable", ["$filter", "IntervalService",
  ($filter, IntervalService) ->

    link = (scope, element, attrs) ->

    templateUrl: "summary_table_tmpl.html" 
    restrict: "E"
    replace: true
    controller: ($scope) ->

    
      

      $scope.$watch "device.modes", ((newval) ->
          if newval && !_.isEmpty(newval)

            $scope.currentGroupModesBy = IntervalService.detectIntervalType(newval)
            $scope.groupModesByOptions = IntervalService.getPermittedGroupModesByOptions($scope.currentGroupModesBy)

        ), true


      $scope.$watch "currentGroupModesBy", (newval) ->
        $scope.groupModesBy = newval



      $scope.modeSumAll = (mode) ->
        mode.acl + mode.norm + mode.idle + mode.fail


      $scope.modeTimeAll = (mode) ->
        mode.duration_acl + mode.duration_norm + mode.duration_idle + mode.duration_fail

      $scope.calcModePerfFact = (mode) -> mode.acl + mode.norm + mode.idle + mode.fail

      $scope.calcModePerfPos = (mode) ->
        svn = mode.duration_norm / mode.norm
        result = ( mode.duration_fail / svn ) - mode.fail
        return 0 unless result
        result

      $scope.calcModePerfPop = (mode) ->
        svn = mode.duration_norm / mode.norm
        result = ( mode.duration_idle / svn ) - mode.idle
        return 0 unless result
        result
      
      $scope.calcModeSsu = (mode) ->
        duration = mode.duration_norm + mode.duration_idle + mode.duration_fail + mode.duration_acl
        cycles = mode.norm + mode.idle + mode.fail + mode.acl
        result = ( duration - mode.idle ) / ( cycles - mode.idle )
        return 0 unless result
        result



     
      

      $scope.perfDisplayOptions = [
        {name: "смыкания", val: "cycles"}
        {name: "изделия", val: "products"}
      ]

      $scope.modesDisplayOptions = [
        {name: "циклы, %", val: "cyclesInPercent"}
        {name: "циклы, шт", val: "cyclesInQt"}
        {name: "часы, %", val: "timeInPercent"}
        {name: "часы, шт", val: "timeInQt"}
      ]

      groupModes = (modes, groupNameTpl) ->
        ks = ["norm", "fail", "idle", "acl", "duration_norm", "duration_fail", "duration_idle", "duration_acl"]
        _.chain modes
          .each (mode) ->
            mode.groupName = $filter('amDateFormat')(new Date(mode.time), groupNameTpl)
          .groupBy (mode) ->
            mode.groupName
          .map (group, k) ->
            time: (_.first group).time
            groupName: k
            values: _.reduce group, ((result, num) ->
              _.each ks, (val) ->
                result[val] = result[val] || 0
                result[val] += num[val]
              result
              ), {}
          .value()


      
      $scope.deviceModesGrouped = false


      $scope.$watch "groupModesBy", (newval) ->
        if newval != $scope.currentGroupModesBy
          
          switch newval
            when "hours" then groupNameTpl = "H_D_M_gggg"
            when "4hours" then groupNameTpl = "H_D_M_gggg"
            when "days" then groupNameTpl = "D_M_gggg"
            when "weeks" then groupNameTpl = "w_gggg"
            when "months" then groupNameTpl = "M_YYYY"
            when "years" then groupNameTpl = "YYYY"

          $scope.modesGrouped = groupModes($scope.device.modes, groupNameTpl)

          $scope.deviceModesGrouped = true
              
        else
          $scope.deviceModesGrouped = false

     
    link: link
]