class ArtistInstrument < ActiveRecord::Base
	validates_presence_of :artist_id
	validates_presence_of :instrument_id
	self.table_name = 'artist_instrument'
end
