require 'carmen'

country_code_allowed = %w(AU CA DE ES FR GB NL NZ US)
file = "/#{Rails.root}/db/data/country_codes.json"
country_codes = JSON::parse(IO.read(file)).select { |x| x['iso'].in? country_code_allowed }

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
