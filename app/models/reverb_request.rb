class ReverbRequest < ActiveRecord::Base
	def self.kickoff_request(artist_id)
		req = ReverbRequest.create!(:artist_id => artist_id)
		instruments = ArtistsInstruments.where(:artist_id => 50).map { |x| Instrument.find(x.instrument_id).name }
		instruments.each { |instrument| Backburner.enqueue(Reverb, req.id, instrument) }
		return req.id
	end
end
