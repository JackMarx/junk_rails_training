Book.destroy_all

100.times do
  Book.create!(
    title: Faker::Book.title,
    author: Faker::Book.author,
    published_on: Faker::Date.between(from: "1850-01-01", to: Date.today),
    cost: Faker::Commerce.price(range: 4.99..149.99)
  )
end

puts "Seeded #{Book.count} books."
