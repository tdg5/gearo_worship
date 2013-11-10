$(function() {

	var $result_list = $('.Results'),
		$search_bar = $('.Header-input'),
    $alert = $('.alert'),
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

	var request_by_name = function(name, use_similar) {
    use_similar = use_similar || false;
		$result_list.empty();
    $alert.hide();
		$spinner.show();
		$spinner.css('display', 'block');
    similar = use_similar ? '?similar=true' : '';
		$.get('/reverb/artist/' + name + similar, function(data){
			if(data.length == 0) {
				$spinner.hide();
        if (use_similar) {
          $alert.html("Couldn't find instruments for artists similar to " + $search_bar.val() + ". Sorry :(");
        } else {
          similar_link = $('<a href="#">similar artists</a>');
          similar_link.click(function() { request_by_name($search_bar.val(), true); });
          $alert.html("Couldn't find instruments for " + $search_bar.val() + ". Try ");
          $alert.append(similar_link);
        }
        $alert.show();
			} else {
				ajax_pester(
					'/reverb/request/' + data, 200,
					 display_reverb_crap,
					function() {
            $alert.html("No instruments currently on sale for " + $search_bar.val() + ".");
            $alert.show();
						$spinner.hide();
					}
				);
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
