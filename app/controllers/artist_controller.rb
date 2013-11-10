class ArtistController < ApplicationController

	def index
		render :text => 'nothing here'
	end


	def get_by_instrument
		render :json => Instrument.find_by_name(params[:instrumet])
	end
end
