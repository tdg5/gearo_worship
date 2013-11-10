require 'nokogiri'
require 'open-uri'

UBER_PRO_AUDIO_DOMAIN = 'http://www.uberproaudio.com'
WHO_PLAYS_WHAT = "#{UBER_PRO_AUDIO_DOMAIN}/who-plays-what"

ARTISTS_REGEX = /(?:(\S.+) - )?(\S.+?)(?:'s)? (?:(?:Guitar|Bass|Drum Kit))/
GEARS_XPATH = '//*[@class="item-page"]/p[contains(., "- ")]'
GEARS_REGEX = /- (.+?)(?:<(?:br|\/p)>)/
TMP_FILE = Rails.root.join('config', 'uberproaudio.json')
SOURCE_NAME = 'UberProAudio'

desc 'Retrieve UberProAudio JSON'
task :retrieve_uber_pro_audio_json do
  doc = Nokogiri::HTML(open(WHO_PLAYS_WHAT))
  artist_urls = doc.css('.list-title a[href]').map do |href|
    url = href.attributes['href'].value
    if url =~ /who-plays-what/
      artist_names = href.text.scan(ARTISTS_REGEX)
      full_url = File.join(UBER_PRO_AUDIO_DOMAIN, url)
      [artist_names.flatten, full_url]
    else
      nil
    end
  end.compact

  artist_gears = nil
  File.open(TMP_FILE, 'w+') do |json|
    json.write('{"entries":[')
    beyond_first = false
    artist_gears = artist_urls.map do |artists, url|
      doc = Nokogiri::HTML(open(url))
      gears = doc.xpath(GEARS_XPATH).map{|node| node.to_s.scan(GEARS_REGEX) }.flatten
      json.write("#{',' if beyond_first}[#{artists.to_json},#{gears.to_json}]")
      beyond_first ||= true
      json.flush
      [artists, gears]
    end
    json.write(']}')
  end
end

desc 'Import UberProAudio JSON'
task :import_json => :environment do
  data = nil
  File.open(TMP_FILE, 'r') do |json|
    data = JSON.parse(json.read)
  end
  source = Source.find_or_create_by(:name => SOURCE_NAME)
  data['entries'].each do |artists, gears|
    artists.each do |artist|
      artist = Artist.find_or_create_by(:name => artist)
      puts "Importing gear for #{artist}"
      gears.each do |gear|
        instrument = Instrument.find_or_create_by(:name => gear[0, 255])
        ArtistsInstruments.find_or_create_by(:source_id => source.id, :instrument_id => instrument.id, :artist_id => artist.id)
        print '.'
      end
    end
  end
end
