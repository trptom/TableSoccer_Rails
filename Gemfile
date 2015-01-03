source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails', '3.2.8'
gem 'rails_12factor'

gem 'i18n', '0.7.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

#gem 'sqlite3'
gem 'pg'
#gem 'mysql2'
# autentizace
gem 'sorcery'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# + Image uploading
gem 'carrierwave'
gem 'cloudinary'

# + Graphical components
gem 'bootstrap-datepicker-rails' # date
gem 'bootstrap-timepicker-rails' # time
gem 'bootstrap-datetimepicker-rails' # date and time

# + Testing
gem 'simplecov', :require => false, :group => :test
group :test do
  gem 'zip-zip', '~> 0.3'
  gem 'selenium-webdriver'
  gem 'test-unit'
  gem 'capybara'
end

# + RSpec for test and dev
group :test, :development do
  gem "rspec-rails"
end

# + Simple text editor
gem 'ckeditor', '4.0.6'
