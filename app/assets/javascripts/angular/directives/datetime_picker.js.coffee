Zoomator.directive "datetimePicker", [ "$filter", "$document", ($filter, $document) ->

  templateUrl: "datetime_picker_tmpl.html"
  replace: true
  restrict: "E"
  


  link: (s,e,a) ->
    e.find('.header__close-btn').on 'click', ->
      s.hidePicker()
      s.$apply()

    $document.on 'click', (e) ->
      s.hidePicker()
      s.$apply()

    e.on 'click', (e) ->
      e.stopPropagation()

  controller: ($scope) ->

    getPickerYears = () ->

      startYear = (new Date $scope.fullPeriod.startDatetime).getFullYear() 

      endYear = (new Date $scope.fullPeriod.endDatetime).getFullYear() 

      if startYear == endYear
        return [startYear]

      else
        return [startYear...endYear]


    getPickerMonths = () ->

       [
          "январь"
          "февраль"
          "март"
          "апрель"
          "май"
          "июнь"
          "июль"
          "август"
          "сентябрь"
          "октябрь"
          "ноябрь"
          "декабрь"
       ]


    getWeekDays = () ->

      [
        "Пн",
        "Вт",
        "Ср",
        "Чт",
        "Пт",
        "Сб",
        "Вс"
      ]

    getDaysInMonth = (month, year) ->
      
      date = new Date(year, month, 1)
      days = []
      while date.getMonth() is month
        days.push new Date(date)
        date.setDate date.getDate() + 1
      days

    detectCalendarShift = (calend) ->

      calendShift = 0

      switch
        when $filter('date')(calend[0],'EEEE') == "понедельник"
          calendShift = 0
        when $filter('date')(calend[0],'EEEE') == "вторник"
          calendShift = 1
        when $filter('date')(calend[0],'EEEE') == "среда"
          calendShift = 2
        when $filter('date')(calend[0],'EEEE') == "четверг"
          calendShift = 3
        when $filter('date')(calend[0],'EEEE') == "пятница"
          calendShift = 4
        when $filter('date')(calend[0],'EEEE') == "суббота"
          calendShift = 5
        when $filter('date')(calend[0],'EEEE') == "воскресенье"
          calendShift = 6

      calendShift



    buildCalendar = (calend) ->

      calendShift = detectCalendarShift(calend)

      newCalend = _.map calend, (n, index) ->

        { 
          dayOfWeek: $filter('date')(n,'EEEE'),
          datetime: n
        }

      _.times calendShift, ->

        newCalend.unshift ""

      newCalend



    $scope.datetimePicker =
      selectedDatetime: new Date
      show: false
      posX: 0
      PosY: 0
      pickType: "begin"
      yearsList: getPickerYears()
      monthLIst: getPickerMonths()
      weekDaysList: getWeekDays()
    
    selectedMonthDays = getDaysInMonth $scope.datetimePicker.selectedDatetime.getMonth(), 
                        $scope.datetimePicker.selectedDatetime.getFullYear()
    
    $scope.calendar = buildCalendar selectedMonthDays

    $scope.selectedHours = (new Date $scope.datetimePicker.selectedDatetime).getHours()

    $scope.selectedMinutes = (new Date $scope.datetimePicker.selectedDatetime).getMinutes()

    $scope.$watch "selectedHours", (newval, oldval) ->
      if newval != oldval
        $scope.changeSelectedDatetimeWithHours(newval)

    $scope.$watch "selectedMinutes", (newval, oldval) ->
      if newval != oldval
        $scope.changeSelectedDatetimeWithMinutes(newval)

    $scope.$watch "datetimePicker.selectedDatetime", ((newval, oldval) ->
      if newval != oldval

        selectedMonthDays = getDaysInMonth $scope.datetimePicker.selectedDatetime.getMonth(),
                              $scope.datetimePicker.selectedDatetime.getFullYear()

        $scope.calendar = buildCalendar selectedMonthDays

        if $scope.datetimePicker.pickType == "begin"

          if newval.getTime() < $scope.fullPeriod.startDatetime
            $scope.selectedPeriod.startDatetime = $scope.fullPeriod.startDatetime

          else

            $scope.selectedPeriod.startDatetime = newval.getTime()

        else 

          if newval.getTime() > $scope.fullPeriod.endDatetime

            $scope.selectedPeriod.endDatetime > $scope.fullPeriod.endDatetime
          else

            $scope.selectedPeriod.endDatetime = newval.getTime()

          # console.log $scope.selectedPeriod

    ), true


    $scope.isSelectedYear = (year) ->

      true if year == $scope.datetimePicker.selectedDatetime.getFullYear()


    $scope.isSelectedDay = (day) ->

      true if (new Date(day.datetime)).getDate() == $scope.datetimePicker.selectedDatetime.getDate()


   
    $scope.isHol = (day) ->

      result = switch 
        when (new Date(day.datetime)).getDay() == 6 then true
        when (new Date(day.datetime)).getDay() == 0 then true

      result

    $scope.hidePicker = ->
      $scope.datetimePicker.show = false

    $scope.changeSelectedDatetimeWithDay = (day) ->

      $scope.datetimePicker.selectedDatetime = new Date day.datetime

    
    $scope.changeSelectedDatetimeWithYear = (year) ->

      d = $scope.datetimePicker.selectedDatetime

      d.setFullYear(year)

      $scope.datetimePicker.selectedDatetime = d

    $scope.changeSelectedDatetimeWithHours = (hours) ->

      if 0 < hours < 24

        d = $scope.datetimePicker.selectedDatetime

        d.setHours(hours)

        $scope.datetimePicker.selectedDatetime = d

      else 

        return false

    $scope.changeSelectedDatetimeWithMinutes = (min) ->

      if 0 < min < 60

        d = $scope.datetimePicker.selectedDatetime

        d.setMinutes(min)

        $scope.datetimePicker.selectedDatetime = d

      else 

        return false



    $scope.nextMonth = () ->

      d = $scope.datetimePicker.selectedDatetime

      d.setMonth(d.getMonth( ) + 1)

      $scope.datetimePicker.selectedDatetime = d

    $scope.prevMonth = () ->

      d = $scope.datetimePicker.selectedDatetime

      d.setMonth(d.getMonth( ) - 1)

      $scope.datetimePicker.selectedDatetime = d
  
  ]
