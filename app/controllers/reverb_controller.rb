class ReverbController < ApplicationController

	def index
	end


	def artist
		artist = Artist.find_by(name: params[:artist_name])
		if artist.nil?
			return render json: ''
		else
			return render json: ReverbRequest.kickoff_request(artist.id)
		end
	end


	def request
		
	end

end
