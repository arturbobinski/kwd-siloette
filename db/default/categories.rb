descriptions = {
  'GoGo Dancer' => 'Dance at events or clubs wearing sexy costumes or lingerie.',
  'Model' => 'Work on photo or video shoots and promotional events',
  'Lingerie Waitress' => 'Serving food, drinks or hosting at parties and events wearing lingerie',
  'Topless Waitress' => 'Serving food, drinks or hosting at parties and events wearing lingerie on the bottom and nothing on top.',
  'Waiter' => 'Serving food, drinks at parties and events'
}

['GoGo Dancer', 'Model'].each do |name|
  Category.find_or_create_by(name: name) do |category|
    category.description = descriptions[name]
  end
end

['Lingerie Waitress', 'Topless Waitress'].each do |name|
  Category.find_or_create_by(name: name) do |category|
    category.kind = 2
    category.description = descriptions[name]
  end
end

# ['Waiter'].each do |name|
#   Category.find_or_create_by(name: name) do |category|
#     category.kind = 0
#     category.description = descriptions[name]
#   end
# end