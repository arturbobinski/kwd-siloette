require 'carmen'

Carmen::Country.all.each do |country|
  Country.where(iso: country.alpha_2_code).first_or_create do |c|
    c.name            = country.name
    c.iso3            = country.alpha_3_code
    c.iso_name        = country.name.upcase
    c.numcode         = country.numeric_code
    c.states_required = country.subregions?
  end
end
