# encoding: UTF-8
require 'nokogiri'
require 'open-uri'
DOMAIN = 'http://www.guitargeek.com'
CATEGORIES = %w[vintage_rigs vulgar_rigs guitar_rigs]
def extract_urls_from_list(url)
	doc = Nokogiri::HTML(open(url))
	return doc.css('.otherposts h3 a[href]').map { |rigs| rigs.attributes['href'].content }
end

def extract_tags(url)
	doc = Nokogiri::HTML(open(url))
	name = doc.title[/(\S.*?) (-|of)/, 1]
	tags = doc.css('a[rel*=tag]')
	return { name => tags.map { |tag| tag.children.first.text }.reject { |text| text =~ /Guitar Rig Archives/ } }
end

def crawl_category(category)
	full_tags = {}
	index = 1

	while true
		list_url = "#{DOMAIN}/category/#{category}/page/#{index}"
		rig_urls = extract_urls_from_list(list_url)	
		puts "got #{list_url}"
		rig_urls.each { |rig_url| full_tags.merge!(extract_tags(rig_url)) }
		index += 1
	end
rescue OpenURI::HTTPError
	return full_tags
end

def crawl_all
	source_id = Source.find_or_create_by(name: 'GuitarGeek')
	tags = CATEGORIES.map { |category| crawl_category(category) }
	tags.first.each { |artist, keywords| 
		artist = Artist.find_or_create_by(name: artist)
		keywords.each { |keyword| 
			instrument = Instrument.find_or_create_by(name: keyword)
			ArtistsInstruments.find_or_create_by(source_id: source_id, instrument_id: instrument.id, artist_id: artist.id)
		}
	}
end

desc 'Load information from Guitar Geek website'
task :load_guitar_geek => :environment do
	crawl_all
end
