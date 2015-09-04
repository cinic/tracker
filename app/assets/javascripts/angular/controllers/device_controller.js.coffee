Zoomator.controller "DeviceController", [
  "$scope"
  "Clamp"
  "Interval"
  "$log"
  "PrepareData"
  "$rootScope"
  "$q"
  "$state"
  ($scope, Clamp, Interval, $log, PrepareData, $rootScope, $q, $state) ->
    defaultStartDate = (+new Date()) - 24 * 60 * 60 * 1000
    defaultEndDate = +new Date()

    setDefaultSelectedPeriod = ->
      $scope.selectedPeriod =
        startDatetime: defaultStartDate
        endDatetime: defaultEndDate

    getFullPeriod = (deviceId) ->
      Clamp.findAll(deviceId, defaultStartDate, defaultEndDate)
           .then (response) ->
              if !$scope.fullPeriod
                $scope.fullPeriod =
                  startDatetime: +new Date response.uptime.startDate
                  endDatetime: defaultEndDate
              $log.info('FullPeriod set')

    getIntervals = (deviceId, selectedPeriod) ->
      Interval.findAll(deviceId, selectedPeriod.startDatetime, selectedPeriod.endDatetime)
              .then (response) -> 
                $scope.device = response.device
                PrepareData.setRawData(response)
              .then ->
                $rootScope.$broadcast('loaded')
                $log.info('Intervals loaded')

    getClamps = (deviceId, selectedPeriod) ->
      Clamp.findAll(deviceId, selectedPeriod.startDatetime, selectedPeriod.endDatetime)
           .then (response) ->
              $scope.clamps = response.clamps
              $log.info('Clamps loaded')

    $scope.init = (deviceId) ->
      $scope.did = deviceId
      getFullPeriod(deviceId).then ->
        $q.when(setDefaultSelectedPeriod()).then ->
          getIntervals(deviceId, $scope.selectedPeriod).then ->
            getClamps(deviceId, $scope.selectedPeriod).then ->
              $state.go 'all'
              $log.info('init DeviceController')

    # defaultModesDisplayIn = 'timeInQt'
    $scope.modesDisplayIn = 'timeInQt'
    $scope.perfDisplayIn = 'cycles'

    updateData = (selectedPeriod) ->
      $scope.modesDataFull = if !_.isEmpty(selectedPeriod) then PrepareData.getModesDataFull($scope.modesDisplayIn) else []
      $scope.modesData = if !_.isEmpty(selectedPeriod) then PrepareData.getModesData($scope.modesDisplayIn) else []
      $scope.perfData = if !_.isEmpty(selectedPeriod) then PrepareData.getPerfData($scope.modesDisplayIn) else []
      $scope.perfDataFull = if !_.isEmpty(selectedPeriod) then PrepareData.getPerfDataFull($scope.modesDisplayIn) else []
      $scope.ctimeData = if !_.isEmpty(selectedPeriod) then PrepareData.getCtimeData($scope.modesDisplayIn) else []
      $scope.ctimeDataFull = if !_.isEmpty(selectedPeriod) then PrepareData.getCtimeDataFull($scope.modesDisplayIn) else []
      $scope.consumpData = if !_.isEmpty(selectedPeriod) then PrepareData.getConsumpData($scope.modesDisplayIn) else []
      $scope.consumpDataFull = if !_.isEmpty(selectedPeriod) then PrepareData.getConsumpDataFull($scope.modesDisplayIn) else []
      
    $scope.$watch "selectedPeriod", ((newval, oldval) ->
        if newval
          getClamps($scope.did, newval).then ->
            getIntervals($scope.did, newval).then ->
              $rootScope.$broadcast "selectedPeriod:updated"
              updateData(newval)
              $log.info('selected period changed in DeviceController')
      ), true

    $scope.$on 'data.grouped', ->
      updateData($scope.selectedPeriod)

    $scope.$watch 'modesDisplayIn', (newval) ->
      $scope.modesData = PrepareData.getModesData(newval)
      $scope.modesDataFull = PrepareData.getModesDataFull(newval)

    $scope.displayModesIn = (kind) ->
      $scope.modesDisplayIn = kind
      # $scope.modesData = PrepareData.getModesData($scope.modesDisplayIn)
      # $scope.modesDataFull = PrepareData.getModesDataFull($scope.modesDisplayIn)
]
