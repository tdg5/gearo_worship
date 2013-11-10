class ReverbController < ApplicationController
  MAX_DEPTH = 10

	def index
	end


	def artist
		artist = Artist.find_by(name: params[:artist_name])
    artist ||= find_similar_artist(params[:artist_name])
		if artist.nil?
			return render json: []
		else
			return render json: ReverbRequest.kickoff_request(artist.id)
		end
	end


	def reverb_request
		still_to_come = ReverbRequestInstrument.where(:request_id => params[:reverb_request_id], :completed => false)
		return render :json => [] if still_to_come.count > 0
		reverb_responses = ReverbResponse.where(request_id: params[:reverb_request_id]).where('response is not null').includes(:instrument)
		json = reverb_responses.map { |reverb_response| ReverbResponseSerializer.new(reverb_response).as_json }
		if json == "[]"
			return render :status => 404
		end
		render :json => json
	end

  private

  def default_serializer_options
    { root: false }
  end


  def find_similar_artist(artist_name)
    depth = 0
    similar_artist = similar_artists = nil
    while similar_artist.nil? && artist_name.present? && depth < MAX_DEPTH
      en_response = Faraday.get("http://developer.echonest.com/api/v4/artist/similar?api_key=#{ECHO_NEST_API_KEY}&name=#{CGI.escape(artist_name)}")
      artists = JSON.parse(en_response.body)['response']['artists'].map!{|artist| artist['name'] }
      # We only want to set similar arists from orignal artist
      similar_artists ||= artists
      similar_artist = Artist.where(:name => artists).first
      artist_name = similar_artists[depth]
      depth += 1
    end
    return similar_artist
  end

end
