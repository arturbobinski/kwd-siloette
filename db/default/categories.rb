descriptions = {
  'Party Host' => 'Work at parties or clubs to greet guests, manage the guest list or serve bottles.',
  'Topless Waitress' => 'Serving guests food or drinks without any clothes on the upper half of your body.',
  'Nude Waitress' => 'Serving guests food or drinks without any clothes on.',
  'Exotic Dance' => 'Dancing and using things like toys without any clothes on.'
}

['Party Host'].each do |name|
  Category.find_or_create_by(name: name) do |category|
    category.kind = 2
    category.description = descriptions[name]
  end
end

['Topless Waitress', 'Nude Waitress', 'Exotic Dance'].each do |name|
  Category.find_or_create_by(name: name) do |category|
    category.description = descriptions[name]
  end
end