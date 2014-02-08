source 'https://rubygems.org'
ruby "2.1.0"
gem 'sinatra'
gem 'thin'
gem 'sinatra-partial'
gem 'rack-flash3'

group :production do
	gem 'newrelic_rpm'
	gem 'unicorn'
end

group :development, :test do
	gem 'shotgun'
end