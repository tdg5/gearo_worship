GearoWorship::Application.routes.draw do

	root :to => 'reverb#index'

	get '/instruments', :to => 'instrument#index'
	get '/instruments/:artist', :to => 'instrument#by_artist'
	get '/artist', :to => 'artist#index'
	get '/reverb/artist/:artist_name', :to => 'reverb#artist'
	get '/reverb/request/:request_id', :to => 'reverb#request'

end
