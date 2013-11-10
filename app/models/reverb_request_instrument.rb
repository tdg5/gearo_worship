class ReverbRequestInstrument < ActiveRecord::Base
	has_one :reverb_response, :foreign_key => :instrument_id
end
