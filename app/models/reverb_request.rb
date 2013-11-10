class ReverbRequest < ActiveRecord::Base
	def self.kickoff_request(artist_id)
		req = ReverbRequest.create!(:artist_id => artist_id)
		instruments = ArtistsInstruments.where(:artist_id => 50).map { |x| Instrument.find(x.instrument_id) }
		instruments.each { |instrument| 
			ReverbRequestInstrument.create!(:request_id => req.id, :instrument_id => instrument.id, :completed => false)
			Backburner.enqueue(Reverb, req.id, instrument.name)
		}

		return req.id
	end
end
