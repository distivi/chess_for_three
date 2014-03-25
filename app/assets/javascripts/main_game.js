$(document).ready(function(){

	var chat_channel = "/messages/" + room_id +"/new";
	PrivatePub.subscribe(chat_channel, function(data, channel) {
		addMessage(data.user,data.color,data.chat_message);
	});

	$("#send-button").click(function(eventObject) {
		textInput = $("#input-text");
		msg = textInput.val();
		textInput.val("");

		$.post("/send_message",
			{room: room_id,
				message: msg,
				user: user_id});
	});

	function addMessage(user_name,color,msg) {
		user_html = "<span class='nickname'>" + user_name + "</span>"
		msg_html = "<p class='msg "+ color+ "'>" + user_html +jQuery('<div>').html(msg).text(); + "</p>";
		var chatDiv = $("#chat");
		
		chatDiv.append(msg_html);

		var height = chatDiv[0].scrollHeight;
		console.log(height);
		chatDiv.scrollTop(height);
	}
});

