require 'carmen'

country_codes = JSON::parse(IO.read("/#{Rails.root}/db/data/country_codes.json"))

Carmen::Country.all.each do |country|
  Country.where(iso: country.alpha_2_code).first_or_create do |c|
    country_code = country_codes.select { |x| x['iso'] == country.alpha_2_code }.first
    c.name            = country.name
    c.iso3            = country.alpha_3_code
    c.iso_name        = country.name.upcase
    c.dial_code       = country_code['dial_code'] if country_code
    c.numcode         = country.numeric_code
    c.states_required = country.subregions?
  end
end
