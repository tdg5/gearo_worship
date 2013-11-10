class CreateReverbRequests < ActiveRecord::Migration
  def change
    create_table :reverb_requests do |t|
      t.integer :artist_id
      t.timestamps
    end
  end
end
