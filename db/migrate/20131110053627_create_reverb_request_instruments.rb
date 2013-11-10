class CreateReverbRequestInstruments < ActiveRecord::Migration
  def change
    create_table :reverb_request_instruments do |t|
      t.integer :request_id
      t.integer :instrument_id
      t.boolean :completed
      t.timestamps
    end
  end
end
