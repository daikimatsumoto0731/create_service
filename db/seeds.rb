# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
vegetable = Vegetable.find_or_create_by(name: 'バジル')
Event.create([
  { vegetable: vegetable, name: '種まき', start_date: Date.today, end_date: Date.today + 7, description: '種まきに関するアドバイス' },
  { vegetable: vegetable, name: '発芽期間', start_date: Date.today + 8, end_date: Date.today + 14, description: '発芽期間に関するアドバイス' },
  { vegetable: vegetable, name: '間引き・雑草抜き・害虫駆除', start_date: Date.today + 15, end_date: Date.today + 21, description: '間引き・雑草抜き・害虫駆除に関するアドバイス' },
  { vegetable: vegetable, name: '収穫期間', start_date: Date.today + 22, end_date: Date.today + 28, description: '収穫期間に関するアドバイス' },
])