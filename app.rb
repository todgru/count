require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

class CountIt

  def self.key
    @key ||= self.generate_new_key
  end

  def self.generate_new_key
    a = ('a'..'z').to_a.concat ('A'..'Z').to_a
    a.shuffle[0,8].join
  end

end

redis = Redis.new

get '/' do
  key = params['key']
  params['key'] = CountIt::key if key.nil?
  redirect "/#{params['key']}"
end

get '/:key' do
  # lookup of key value
  @current_count = redis.hget( 'countit', params['key'] ).to_i
  params['current_count'] = @current_count
  erb :index
end

post '/:key' do
  c = redis.hget( 'countit', params['key'] ).to_i
  @current_count = c + params['item_count'].to_i
  redis.hset( 'countit', params['key'], @current_count )
  params['current_count'] = @current_count
  erb :index
end

