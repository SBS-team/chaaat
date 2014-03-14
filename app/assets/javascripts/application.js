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
//= require turbolinks
//= require bootstrap


//= require_tree

//$(document).ready(function(){
//    $("#send_message").click(function(){
//        $.ajax({
//            type: "POST",
//            url: "message/new",
//            data: { message: $("#message").val() }
//        })
//            .done(function(msg) {
//                $("#message").val('');
//            });
//    });
//
//
//    Pusher.log = function(message) {
//        if (window.console && window.console.log) {
//            window.console.log(message);
//        }
//    };
//
////    Pusher.channel_auth_endpoint = '/api/authenticate?user_id=' + user_id;
////    var pusher = new Pusher('255267aae6802ec7914f');
////    var channel = pusher.subscribe(gon.user_id.toString());
//
//
//    Pusher.channel_auth_edpoint = '/api/authenticate/'
//    var socket = new Pusher('255267aae6802ec7914f');
//
//// Global variable "channel" is set in the view
////    var presenceChannel = socket.subscribe('presence-' + channel);
//    var channel = socket.subscribe(gon.user_id.toString());
//
//    channel.bind('my_event', function(data) {
//        $('#messages').append(data.firstname+':'+data.message+"<br>");
//    });

//    $(function() {
//
//
//        // Some useful debug msgs
//        pusher.connection.bind('connecting', function() {
//            $('div#status').text('Connecting to Pusher...');
//        });
//        pusher.connection.bind('connected', function() {
//            $('div#status').text('Connected to Pusher!');
//        });
//        pusher.connection.bind('failed', function() {
//            $('div#status').text('Connection to Pusher failed :(');
//        });
//        channel.bind('subscription_error', function(status) {
//            $('div#status').text('Pusher subscription_error');
//        });
//    });


//});


//    $('#messages' + 'fffffffffff').hide();
//  Pusher.channel_auth_endpoint = '/pusher/auth?user_id=' +gon.user_id.toString();


