class RenameArtistInstrumentToArtistsInstruments < ActiveRecord::Migration
  def change
	rename_table :artist_instrument, :artists_instruments
  end
end
