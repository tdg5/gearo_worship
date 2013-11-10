$(function() {

	var $result_list = $('.Results'),
		$search_bar = $('.Header-input'),
		$spinner = $('.AjaxLoader'),
		request_id;


	var display_reverb_crap = function(data) {
		var result_elements = [];

		console.log(data);
		$spinner.hide();

		for (var i = 0; i < data.length; i++) {
			var instrument = data[i];
			instrument['listing'] = Mustache.render(Templates['Reverb::Listing'], instrument['listings'][0]);
			instrument_markup = Mustache.render(Templates['Reverb::Instrument'], instrument);
			result_elements.push(instrument_markup);
		}
		$result_list.append(result_elements.join('\n'));
	}

	var request_by_name = function(name) {
		$result_list.empty();
		$spinner.show();
		$spinner.css('display', 'block');
		$.get('/reverb/artist/' + name, function(data){
			if(data.length == 0) {
				$spinner.hide();
				alert('no instruments for that artist :/');
			} else {
				ajax_pester('/reverb/request/' + data, 200, display_reverb_crap);
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
