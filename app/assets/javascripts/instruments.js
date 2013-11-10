$(function() {

	$('.artist').keypress(function(e) {
		var code = (e.keyCode ? e.keyCode : e.which);
		if(code == 13) {
			e.preventDefault();
			$.get('/instruments/' +$(this).val(), function(data){
				rebuild_instrument_list(data);
			});
		}
	});

	var rebuild_instrument_list = function(data) {
		var $instrument_list = $('.instruments'),
			instruments = [];
		$instrument_list.empty();
		for(var i = data.length; i > 0; i--) {
			instruments.push('<ul>' + data[i - 1].name + '</ul>');
		}
		$instrument_list.append(instruments.join('\n'));
	}
});
