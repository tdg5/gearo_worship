class InstrumentController < ApplicationController

	def index
	end

	def by_artist
		render :json => Artist.find_by_name(params[:artist].downcase).instruments
	end
end
