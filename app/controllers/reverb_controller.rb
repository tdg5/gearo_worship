class ReverbController < ApplicationController
  MAX_DEPTH = 3

	def index
	end


	def artist
		artist = Artist.find_by(name: params[:artist_name])
    artist ||= find_similar_artist(params[:artist_name]) if params[:similar].try(:downcase) == 'true'
		if artist.nil?
			return render json: []
		else
			return render json: ReverbRequest.kickoff_request(artist.id)
		end
	end


	def reverb_request
		good_enough = 15
		so_far = ReverbRequestInstrument.where(:request_id => params[:reverb_request_id], :completed => true)
		still_to_come = ReverbRequestInstrument.where(:request_id => params[:reverb_request_id], :completed => false)
		lets_show_it = so_far.count >= good_enough || still_to_come.count == 0
		if lets_show_it
			reverb_responses = ReverbResponse.where(request_id: params[:reverb_request_id]).where('response is not null').includes(:instrument)
			json = reverb_responses.map { |reverb_response| ReverbResponseSerializer.new(reverb_response).as_json }
			if json == []
				return render :json => json, :status => 404
			end
			return render :json => json
		else
			return render :json => []
		end
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
