import 'selectize/dist/js/selectize.min.js';

$(function(){
	$("#select-intentions").selectize({
		maxItems: 5,
		delimiter: ',',
		allowEmptyOption: true
	});
});
