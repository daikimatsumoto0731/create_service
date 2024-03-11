source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.4'

gem 'rails', '~> 7.0.8'
# SQLiteは開発とテストでのみ使用
# gem 'sqlite3' # この行を削除
gem 'puma', '~> 5.0'
gem 'sassc-rails', '~> 2.1'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'devise', '~> 4.8'

gem 'omniauth-line', '<= 2.1.2'
gem 'omniauth-rails_csrf_protection'
gem 'devise-i18n'
gem 'webpacker'
gem 'dotenv-rails'

gem 'bootstrap', '~> 5.0'
gem 'jquery-rails'
gem 'line-bot-api'

gem 'momentjs-rails'
gem 'httparty'
gem 'whenever', require: false
# gem 'pg', "~> 1.5" # この行を移動

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'sqlite3', '~> 1.4' # SQLiteをここに移動
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.1.0'
  gem 'letter_opener'
  gem "dockerfile-rails", ">= 1.6"
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'webdrivers', '~> 4.0'
end

group :production do
  gem 'pg', '~> 1.5' # PostgreSQLを本番環境用にここに追加
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
