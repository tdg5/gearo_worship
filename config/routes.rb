GearoWorship::Application.routes.draw do

	root :to => 'reverb#index'

	get '/instruments', :to => 'instrument#index'
	get '/instruments/:artist', :to => 'instrument#by_artist'
	get '/artist', :to => 'artist#index'

end
