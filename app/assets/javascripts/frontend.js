// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require snap.svg-min
//= require ./frontend/snap_patch
//= require lodash
//= require angular.min
//= require angular-locale_ru-ru
//= require angular-rails-templates
//= require angular-ui-router.min
//= require loading-bar
//= require angular-cookie
//= require_tree ../templates
//= require ya-map-2.1.min
//= require angular_application
//= require angular-duration
//= require d3
//= require d3-tip
//= require moment
//= require angular-moment
//= require frontend/devices




$(function(){ $(document).foundation(); });


$(window).bind("load", function () {
    var footer = $(".footer");
    var pos = footer.position();
    var height = $(window).height();
    height = height - pos.top;
    height = height - footer.height();
    if (height > 0) {
        footer.css({
            'margin-top': height + 'px'
        });
    }
});

