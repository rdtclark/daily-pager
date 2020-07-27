var renderTimeoutMessage = function (){
	alert("timeout");
	// pull up modal with error and message to email us
}


$(document).on("turbolinks:load", function() {
// $(document).ready(function() {
	var poll;
	var attempts = 0;
	poll = function(div, callback) {
		return setTimeout(function() {
			return $.get(div.data('status')).done(function(journal) {
				if (journal.processing) {
					if (attempts > 4){
						renderTimeoutMessage();
						return false;
					} else {
						attempts += 1;
						return poll(div, callback);
					}
				} else {
					return callback();
				}
			});
		}, 1000 * (attempts + 1));
	};
	return $('[data-status]').each(function() {
		var div;
		div = $(this);
		return poll(div, function() {
			$("#message-container").hide()
			$.getScript($('#preview-container').data("url"))
		});
	});
});
