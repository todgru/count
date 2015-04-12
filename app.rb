require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

get '/' do
  erb :index
end

post '/' do
  @count = @params['item_count'].to_i
  erb :index
end

