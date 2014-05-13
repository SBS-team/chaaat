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
//= require handlebars-v1.3.0
//= require jquery_ujs
//= require emojify
//= require audiojs
//= require jquery.bootstrap-growl
//= require jquery.confirm.min.js
//= require jquery.overlay
//= require jquery.textcomplete.min
//= require jquery.nanoscroller.js
//= require jquery.blockUI
//= require jquery.nanoscroller.js
//= require socket.io
//= require RTCPeerConnection-v1.5
//= require conference
//= require user
//= require main
//= require jquery.timeago.js
//= require messages
//= require pusher
//= require bootstrap
//= require rooms
//= require video

//$(document).ready(function(){
//$(".video-chat").click(function() {
//    if (document.getElementById("video.js")){
//        src=document.getElementById("video.js")
//        src.remove();
//        $('script[src="' + src + '"]').remove()
//    }
//
//
//
//    var fileref=document.createElement('script');
////the Date added to the file doesn't effect the results but helps IE be sure to refresh the data and not use cache
//
//    var d = new Date();
//    var t = d.getTime();
//    fileref.setAttribute("src", "/assets/video.js?date="+t);
//    fileref.setAttribute("id", "video.js");
////    $('head').append(fileref);
//    console.log("fileref",fileref);
//
//
//
//      $('<script>').attr('src', "/assets/video.js?date="+t).appendTo('head')
//});
//});