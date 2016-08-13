# encoding: UTF-8 
languages_hash = JSON::parse(IO.read("/#{Rails.root}/db/data/languages.json"))

languages_hash.keys.each do |k|
  Language.find_or_create_by(code: k) do |l|
    l.name = languages_hash[k]['name']
    l.native_name = languages_hash[k]['nativeName']
    l.active = true
  end
end

