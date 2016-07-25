require "redis"

def redis
  #@redis ||= Redis.new(:host => "127.0.0.1", :port => 6379)
  @redis ||= Redis.new(:host => config.redis.host, :port => config.redis.port, :password => config.redis.password)
end

=begin USAGE example
def fibonacci (n)
  return n if n <= 1
  fibonacci(n - 1) + fibonacci(n - 2)
end

result = memo "fib", 35 do |key|
  fibonacci(key)
end
puts result
=end
