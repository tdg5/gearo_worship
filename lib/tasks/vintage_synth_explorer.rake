require 'nokogiri'
require 'open-uri'
VINTAGE_SYNTH_EXPLORER_URL = 'http://www.vintagesynth.com'


def extract_makes_from_index(doc)
	makes = {}
	doc.css('.ajaxLink').each do |link|
		makes[link.text.to_sym] = {
			:href => (VINTAGE_SYNTH_EXPLORER_URL + link.attributes['href'].value) + '/',
		}
	end
	return makes
end

def extract_synths_from_make(doc)
	synths = {}
	doc.css('.hide_click').each do |link|
		synths[link.text[2..999].to_sym] = {
			:href => (VINTAGE_SYNTH_EXPLORER_URL + link.attributes['href'].value),
		}
	end
	return synths
end

def extract_artists_from_synth(doc)
	artists = []
	doc.css('#left_col p b').each do |list|
		list = list.text.split ','
		list.map! {|a| a.gsub(/\n*/, '').gsub(/^\s*.and\s+/, '').gsub(/^\s*/, '')}
		artists += list
	end
	return artists
end

task :import_vintage_synth_explorer_data_set => :environment do
	#binding.pry
	doc = Nokogiri::HTML(open(VINTAGE_SYNTH_EXPLORER_URL))
	source = Source.find_or_initialize_by(name: 'vintage synth explorer')
	source.save
	@makes = extract_makes_from_index doc
	@makes.each do |make, make_attrs|
		doc = Nokogiri::HTML(open(make_attrs[:href]))
		make_attrs[:synths] = extract_synths_from_make doc
		make_attrs[:synths].each do |synth, synth_attrs|
			puts "#{make.to_s} #{synth.to_s}".downcase
			instrument = Instrument.find_or_initialize_by(name: "#{make.to_s} #{synth.to_s}".downcase)
			next unless instrument.save
			doc = Nokogiri::HTML(open(synth_attrs[:href]))
			synth_attrs[:artists] = extract_artists_from_synth doc
			synth_attrs[:artists].each do |artist|
				artist = Artist.find_or_initialize_by(name: artist.to_s.downcase)
				next unless artist.save
				mapping = ArtistInstrument.find_or_initialize_by(artist_id: artist.id, instrument_id: instrument.id, source_id: source.id)
				mapping.save
			end
		end
	end
end
