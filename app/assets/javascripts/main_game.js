$(document).ready(function(){

	if (user_name && user_color) {
		add_online_user(user_name,user_color);
	};

	var chat_channel = "/messages/" + room_id +"/new";
	PrivatePub.subscribe(chat_channel, function(data, channel) {
		addMessage(data.user,data.color,data.chat_message);
	});

	var user_connected_channel = "/messages/" + room_id + "/user_connected";
	PrivatePub.subscribe(user_connected_channel, function(data, channel) {
		add_online_user(data.user,data.color);
	});

	var user_disconnected_channel = "/messages/" + room_id + "/user_disconnected";
	PrivatePub.subscribe(user_disconnected_channel, function(data, channel) {
		$(".online").filter(function() {
		    return $(this).text() === data.user;
		}).last().remove();
	});

	$("#send-button").click(function(eventObject) {
		sendMessage();
	});

	function sendMessage() {
		textInput = $("#input-text");
		msg = textInput.val();
		textInput.val("");

		$.post("/send_message",
			{room: room_id,
				message: msg,
				user: user_id});
	}

	function addMessage(user_name,color,msg) {
		user_html = "<span class='nickname'>" + user_name + "</span>"
		msg_html = "<p class='msg "+ color+ "'>" + user_html +jQuery('<div>').html(msg).text(); + "</p>";
		var chatDiv = $("#chat");
		
		chatDiv.append(msg_html);

		var height = chatDiv[0].scrollHeight;
		console.log(height);
		chatDiv.scrollTop(height);
	}

	function add_online_user(name,color) {
		var identifier;

		if (color == "guest") {
			var identifier = "class='online player-guest' "
		} else {
			var identifier = "class='online' id='player-" + color + "' "
		};

		user_html = "<div " + identifier +" >" + name + "</div>";

		$("#online-block").append(user_html);
	}

	$('#input-text').bind('keypress',function (event){
		if (event.keyCode === 13){
			sendMessage();
		}
	});

	$(window).unload(function(){
	  console.log("unload user disconect");
	  		$.post("/leave_chat",
	  			{room: room_id,
	  			user: user_id});
	});
});

