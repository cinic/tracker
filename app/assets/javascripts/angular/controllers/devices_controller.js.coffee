Zoomator.controller "DevicesController", [
  "$scope"
  "$http"
  "Device"
  "IntervalService"
  "$q"
  "$filter"
  "ipCookie"
  "SelectedPeriod"
  "FullPeriod"
  "FactorComputate"
  "Uptime"
  "$rootScope"
  ($scope, $http, Device, IntervalService, $q, $filter, ipCookie, SelectedPeriod, FullPeriod, FactorComputate, Uptime, $rootScope) ->

    ###*
     * setup periods 
    ###

    $scope.zoomColors = []

    $scope.fullPeriod =
      startDatetime: FullPeriod.startDatetime
      endDatetime: FullPeriod.endDatetime

    $scope.selectedPeriod =
      startDatetime: SelectedPeriod.startDatetime
      endDatetime: SelectedPeriod.endDatetime

    $scope.devices = []

    $scope.markerHeight = $scope.devices.length * 120

    ###*
     * initialize timeline component
    ###
    
    $scope.initTimeline = () ->

      if !_.isEmpty($scope.devices)
      
        $scope.markerHeight = $scope.devices.length * 120

    ###*
      ==== async fetch all devices on current user account ====

       1. fetch all devices and its full intervals
       2. calculate fullPeriod begin and end
    ###

    $scope.initDevices = ->
      Device.getDevices()
        .then (result) -> 
          $scope.devices = result.data.devices
          $scope.fullPeriod.startDatetime = +new Date(result.data.uptime.start)
          if ((+new Date(result.data.uptime.end)) > +new Date)
            $scope.fullPeriod.endDatetime = +new Date(result.data.uptime.end)
          else 
            $scope.fullPeriod.endDatetime = +new Date
          
          
  
          # $q.all(fullIntervalspromises)
          #   .then (results) ->
          #     _.each results, (result, index) ->
          #       $scope.devices[index].fullIntervals = result
          #   .then ->
          #     FullPeriod.update _.pluck($scope.devices, "fullIntervals")
          #     $scope.fullPeriod.startDatetime = FullPeriod.startDatetime
          #     $scope.fullPeriod.endDatetime = FullPeriod.endDatetime
              
    ###*
     * 3. fetch intervals for all devices for last selectedPeriod
    ###

    $scope.loadIntervals = ->

      intervalPromises = []

      _.each $scope.devices, (device) ->
        intervalPromises.push Device.getDeviceIntervals(device.id, $scope.selectedPeriod.startDatetime, $scope.selectedPeriod.endDatetime)

      $q.all(intervalPromises)
        .then (results) ->
          _.each results, (result, index) ->
            $scope.devices[index].intervals = result

    ###*
     * initialize controller
    ###

    $scope.init = ->
      
      $scope.initDevices()
        # .then ->
        #   $scope.loadIntervals()
            .then ->
              $scope.initTimeline()

    $scope.init()

    ###*
     * scope watchers
    ###

    $scope.$watch "selectedPeriod", ((newval, oldval) ->
      if newval != oldval
        if newval.startDatetime < FullPeriod.startDatetime
          start = FullPeriod.startDatetime
        else
          start = newval.startDatetime
        if newval.endDatetime > FullPeriod.endDatetime
          end = FullPeriod.endDatetime
        else
          end = newval.endDatetime
        # $scope.loadIntervals()
        SelectedPeriod.update(start, end)
        SelectedPeriod.saveToCookies()

      ), true
    

]