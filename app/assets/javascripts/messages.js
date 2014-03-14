$(document).ready(function(){

	$("#send_message").click(function(){
		$.ajax({
		  type: "POST",
		  url: "../message/new",
		  data: { message: $("#message").val() }
		})
		  .done(function(msg) {
		  	$("#message").val('');
		  });
	});

	$("#search").keyup(function(){
		$.ajax({
		  type: "POST",
		  url: "../message/search/",
		  data: { query: $("#search").val() }
		})
		  .done(function(msg) {
		  	$('#messages-wrapper').html('');
		  	for (var i = 0; i <= msg.length - 1; i++) {
		  		render_message(msg[i].user_id,msg[i].login,msg[i].body,msg[i].created_at);
		  	};
		  });
	});

$("#message").keyup(function(){
		if ((this.value.indexOf(' @')>-1) || (this.value.indexOf('@')>-1 && this.value.indexOf('@')<1)){
			
		}
	});

    var pusher = new Pusher('255267aae6802ec7914f');
    var channel = pusher.subscribe('chaaat');
    channel.bind('new_message', function(data) {
        render_message(data.user_id,data.login,data.message,data.create_at);
    });


function render_message(user_id,login,body,time){
	if(gon.user_id==user_id){
	  $('#messages-wrapper').append("<div class=\"message to\">"+login+': '+body+"<span class=\"pull-right time\">"+time+"</span></div>");
	}else{
	  $('#messages-wrapper').append("<div class=\"message from\">"+login+': '+body+"<span class=\"pull-right time\">"+time+"</span></div>");
	}
}

});