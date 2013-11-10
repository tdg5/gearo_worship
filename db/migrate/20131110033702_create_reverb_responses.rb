class CreateReverbResponses < ActiveRecord::Migration
  def change
    create_table :reverb_responses do |t|
	  t.integer :request_id
      t.text :response
      t.timestamps
    end
  end
end
