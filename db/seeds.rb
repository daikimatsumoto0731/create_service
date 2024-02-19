# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# 野菜の作成または取得
basil = Vegetable.find_or_create_by(name: 'バジル')
carrot = Vegetable.find_or_create_by(name: 'にんじん')
tomato = Vegetable.find_or_create_by(name: 'トマト')

# バジルのイベント
Event.create(vegetable: basil, name: "種まき", start_date: Date.today, end_date: Date.today + 5.days)
Event.create(vegetable: basil, name: "発芽期間", start_date: Date.today + 5.days, end_date: Date.today + 25.days)
Event.create(vegetable: basil, name: "間引き・雑草抜き・害虫駆除", start_date: Date.today + 25.days, end_date: Date.today + 65.days)
Event.create(vegetable: basil, name: "収穫期間", start_date: Date.today + 65.days, end_date: Date.today + 105.days)

# にんじんのイベント
Event.create(vegetable: carrot, name: "種まき", start_date: Date.today, end_date: Date.today + 10.days)
Event.create(vegetable: carrot, name: "発芽期間", start_date: Date.today + 10.days, end_date: Date.today + 40.days)
Event.create(vegetable: carrot, name: "間引き・雑草抜き・害虫駆除", start_date: Date.today + 40.days, end_date: Date.today + 90.days)
Event.create(vegetable: carrot, name: "収穫期間", start_date: Date.today + 90.days, end_date: Date.today + 170.days)

# トマトのイベント
Event.create(vegetable: tomato, name: "種まき", start_date: Date.today, end_date: Date.today + 5.days)
Event.create(vegetable: tomato, name: "発芽期間", start_date: Date.today + 5.days, end_date: Date.today + 35.days)
Event.create(vegetable: tomato, name: "間引き・雑草抜き・害虫駆除", start_date: Date.today + 35.days, end_date: Date.today + 95.days)
Event.create(vegetable: tomato, name: "収穫期間", start_date: Date.today + 95.days, end_date: Date.today + 175.days)
