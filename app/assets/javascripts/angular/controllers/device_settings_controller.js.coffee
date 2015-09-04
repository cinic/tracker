Zoomator.controller "DeviceSettings", [
  "$scope", 
  "Device", 
  "$stateParams",
  "$state"
  ($scope, Device, $stateParams, $state) ->

    deviceId = $stateParams.deviceId

    if deviceId 
      Device.getDevice(deviceId).then (device) ->
        $scope.device = device
    else
      $scope.device =
        schedule: "default"
        interval: "1 час"

    $scope.saveDevice = () ->
      $scope.device.normal_cycle = [$scope.device.normal_cycle.target, $scope.device.normal_cycle.accuracy].join(', ')
      Device.createNew($scope.device)
            .then(((result)-> 
              console.log($scope.device)
              $state.go('Base')), ((errors)-> 
              $scope.device.errors = errors.data
              console.log($scope.device.errors)))
]