$(function() {

	var $search_bar = $('.Header-input'),
		$spinner = $('.AjaxLoader'),
		request_id;


	var display_reverb_crap = function(data) {
		var $result_list = $('.Results'),
			result_elements = [];
		
		console.log(data);
		$spinner.hide();

		$result_list.empty();
		for(var i = data.length - 1; i>=0; i--) {
			var key;
			for (var k in data[i]) {
			    key = k;
			}
			var item = data[i][k][0];
			if(!item){ continue };
			var desc = item['description'];
			if(!desc){ continue };
			result_elements.push('<ul>' + desc + '</ul>');
		}
		$result_list.append(result_elements.join('\n'));
	}

	var request_by_name = function(name) {
		$.get('/reverb/artist/' + name, function(data){
			if(data.length == 0) {
				alert('no instruments for that artist :/');
			} else {
				$spinner.show();
				$spinner.css('display', 'block');
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
