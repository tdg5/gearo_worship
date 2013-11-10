class ReverbResponseSerializer < ActiveModel::Serializer
  self.root = false
  attributes

  PRICE_FUNCTION = lambda {|listing| listing['price']['amount'].to_f }

  def attributes
    listings = JSON.parse(object.response)
    listings.map! do |listing|
      listing['description_preview'] = description_preview(listing['description'])
      photo = photo_url(listing)
      listing['photo_url'] = photo if photo.present?
      url = listing['_links']['web']['href']
      listing['url'] = url if url.present?
      listing
    end
    prices = price_range(listings)
    return {
      :listings => listings,
      :price_range_min => prices.first,
      :price_range_max => prices.last,
      :instrument_name => object.instrument.name,
    }
  end


  def description_preview(description)
    return "#{description[0, 196]} ..."
  end


  def photo_url(listing)
    first_photo = listing['photos'][0]
    return first_photo.present? ? first_photo['_links']['large_crop']['href'] : nil
  end


  def price_range(listings)
    min_listing = listings.min_by(&PRICE_FUNCTION)
    max_listing = listings.max_by(&PRICE_FUNCTION)
    return [min_listing, max_listing].map do |listing|
      [listing['price']['symbol'], listing['price']['amount']].join
    end
  end

end
