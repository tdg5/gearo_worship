class ChangeResponseToLongText < ActiveRecord::Migration
  def change
	change_column :reverb_responses, :response, :text, :limit => 16777215
  end
end
