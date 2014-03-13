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
		  	$('#messages').html('');
		  	for (var i = 0; i <= msg.length - 1; i++) {
		  		$('#messages').append(msg[i].user_id+':'+msg[i].body+"<span class=\"pull-right\">"+msg[i].created_at+"</span><br>");
		  	};
		  });
	});




});