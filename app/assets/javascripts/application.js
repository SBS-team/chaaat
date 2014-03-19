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
//= require bootstrap


//= require_tree

$(document).ready(function(){
	$("#send_message").click(function(){
		$.ajax({
		  type: "POST",
		  url: "message/new",
		  data: { message: $("#message").val() }
		})
		  .done(function(msg) {
		  	$("#message").val('');
		  });
	});


    Pusher.log = function(message) {
      if (window.console && window.console.log) {
        window.console.log(message);
      }
    };

    var pusher = new Pusher('255267aae6802ec7914f');
    var channel = pusher.subscribe('chaaat');
    channel.bind('my_event', function(data) {
        $('#messages').append(data.firstname+':'+HtmlEncode(data.message)+"<br>");
    });
});

function HtmlEncode(val) {

    return $("<div/>").text(val).html();
}
