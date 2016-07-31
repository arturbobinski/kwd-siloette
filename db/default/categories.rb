descriptions = {
  'Party Host' => 'Work at parties or clubs to greet guests, manage the guest list or serve bottles.',
  'Model' => 'Work on photo or video shoots and promotional events',
  'Waitress' => 'Serving food, drinks at parties and events',
  'Waiter' => 'Serving food, drinks at parties and events'
}

['Party Host', 'Model'].each do |name|
  Category.find_or_create_by(name: name) do |category|
    category.description = descriptions[name]
  end
end

['Waitress'].each do |name|
  Category.find_or_create_by(name: name) do |category|
    category.kind = 2
    category.description = descriptions[name]
  end
end

['Waiter'].each do |name|
  Category.find_or_create_by(name: name) do |category|
    category.kind = 0
    category.description = descriptions[name]
  end
end