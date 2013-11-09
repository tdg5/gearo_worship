class CreateTables < ActiveRecord::Migration
  def change
    create_table :artists do |t|
	t.string :name
    end

    create_table :instruments do |t|
	t.string :name
    end

    create_table :sources do |t|
	t.string :name
    end

    create_table :artist_instrument do |t|
	t.integer :artist_id
	t.integer :instrument_id
	t.integer :source_id
    end
  end
end
