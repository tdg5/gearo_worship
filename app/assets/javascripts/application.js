// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery_ujs
//= require turbolinks
//= require mustache.min
//= require templates
//= require_tree .

var ajax_pester = function(url, retries, success, failure) {
	var retry_limit = retries;

	function retry_interval(retries_remaining) {
		retry_index = retry_limit - retries_remaining;
		return (Math.random() + 1) * 0.66 * Math.pow(1.4, retry_index);
	}

	function request(retries) {
		$.ajax({
			type: "GET",
			dataType: "json",
			url: url,
			success: function(data) {
				if(data.length == 0 && retries > 0) {
					setTimeout(function() { request(retries - 1); }, retry_interval(retries - 1));
				} else {
					if(data.length > 0) {
						if(typeof success == 'function') success(data);
					} else {
						if(typeof failure == 'function') failure(data);
					}
				}
			},
			error: function(data) {
				if(typeof failure == 'function') failure(data);
			}
		});
	}

	request(retries);
}
