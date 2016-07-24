require "redis"
require_relative "./load_config"

class RedisClient
  attr_reader :host, :port
  def initialize (file, overwrite_opts = {})
    config = Config.new(file).load
    @host = overwrite_opts[:host] || overwrite_opts["host"] || config.redis.host
    @port = overwrite_opts[:port] || overwrite_opts["port"] || config.redis.port
    @redis = Redis.new(:host => host, :port => port)
  end
  def client
    @redis
  end
end

redis = RedisClient.new("../config.yml", {:host => "127.0.0.1", :port => 6379}).client

# redis is ready to use
puts redis.get("foo")






