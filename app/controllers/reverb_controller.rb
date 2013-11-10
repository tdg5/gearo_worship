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


	def reverb_request
		still_to_come = ReverbRequestInstrument.where(:request_id => params[:reverb_request_id], :completed => false)
		return render json: '' if still_to_come.count > 0
		reverb_responses = ReverbResponse.where(request_id: params[:reverb_request_id])
		json_structure = reverb_responses.map { |reverb_response| 
			instrument = Instrument.find(reverb_response.instrument_id)
			{ instrument.name => JSON.parse(reverb_response.response) }
		}
		return render json: JSON.generate(json_structure)
	end

end
