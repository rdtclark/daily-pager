$(document).ready(function() {

	var i = 1;
	var sampleMessages = [ "Sharpening Pencils", "Looking for the scissors", "Coloring In", "Doh! Rubbing out" ];
	setInterval(function() {
		var newText = sampleMessages[i++ % sampleMessages.length];
		$("#message").find('h3').fadeOut(500, function () {
			$(this).text(newText).fadeIn(500);
		});
	}, 1 * 3000);

});
