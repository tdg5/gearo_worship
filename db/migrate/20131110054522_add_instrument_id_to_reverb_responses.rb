class AddInstrumentIdToReverbResponses < ActiveRecord::Migration
  def change
	add_column :reverb_responses, :instrument_id, :integer
  end
end
