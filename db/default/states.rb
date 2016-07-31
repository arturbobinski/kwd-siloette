Country.where(states_required: true).each do |country|
  carmen_country = Carmen::Country.named(country.name)
  carmen_country.subregions.each do |subregion|
    country.states.where(abbr: subregion.code).first_or_create do |s|
      s.name = subregion.name
    end
  end
end
