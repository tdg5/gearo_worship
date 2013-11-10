$(function() {

	var $search_bar = $('.Header-input'),
		$spinner = $('.AjaxLoader'),
		request_id;


	var display_reverb_crab = function(name) {
	}

	var request_by_name = function(name) {
		$.get('/reverb/artist/' + name, function(data){
			if(data == null) {
				alert('no instruments for that artist :/');
			} else {
				$spinner.show();
				ajax_pester('/reverb/request/' + data, 20, display_reverb_crap);
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

	$search_bar.keypress(function(e) {
		var code = (e.keyCode ? e.keyCode : e.which);
		if(code == 13) {
			e.preventDefault();
			request_by_name($search_bar.val());
		}
	});
});
