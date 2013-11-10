require 'faraday'
module Reverb
	def self.queue
		'reverb_requests'
	end

	def self.find_listings(request_id, keyword)
		conn = Faraday.new(:url => 'https://reverb.com:443')
		response = conn.get do |req|
			req.url '/api/listings.json'
			req.params['query'] = keyword
			req.headers['X-Auth-Token'] = AUTH_TOKEN
		end
		instrument = Instrument.find_by(name: keyword)
		rec = ReverbRequestInstrument.find_by(request_id: request_id, instrument_id: instrument.id)
		rec.completed = true
		rec.save
		response_json = JSON.generate(JSON.parse(response.body)['listings'])
		ReverbResponse.create!(:request_id => request_id, :response => response_json. :instrument_id => instrument.id)
	end

end
