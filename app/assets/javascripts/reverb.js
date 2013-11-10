$(function() {

	var $search_bar = $('.Header-input'),
		request_id;

	var request_by_name = function(name) {
		$.get('/reverb/artist/' + name, function(data){
			if(data.length) {
				request_id = data;
				alert(request_id);
			} else {
				 alert('no instruments for that artist :/');
			}
		});
	};

	var rebuild_instrument_list = function(data) {
		var $instrument_list = $('.instruments'),
			instruments = [];
		$instrument_list.empty();
		for(var i = data.length; i > 0; i--) {
			instruments.push('<ul>' + data[i - 1].name + '</ul>');
		}
		$instrument_list.append(instruments.join('\n'));
	}

	$searh_bar.keypress(function(e) {
		var code = (e.keyCode ? e.keyCode : e.which);
		if(code == 13) {
			e.preventDefault();
			request_by_name($(this).val());
		}
	});
});
