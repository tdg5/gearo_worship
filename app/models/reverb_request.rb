class ReverbRequest < ActiveRecord::Base
	def self.kickoff_request(artist_id)
		req = ReverbRequest.create!(:artist_id => artist_id)
		instruments = Artist.find(artist_id).instruments.first(15)
		instruments.each { |instrument| 
			ReverbRequestInstrument.create!(:request_id => req.id, :instrument_id => instrument.id, :completed => false)
			Backburner.enqueue(Reverb, req.id, instrument.name)
		}

		return req.id
	end
end
