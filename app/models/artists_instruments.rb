class ArtistsInstruments < ActiveRecord::Base
	self.table_name = 'artists_instruments'

	validates_presence_of :artist_id
	validates_presence_of :instrument_id
end
