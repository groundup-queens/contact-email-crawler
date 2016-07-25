require_relative "./redis"

$redis = RedisClient.new("../config.yml", {:host => "127.0.0.1", :port => 6379}).client

def memo (redis, func, input) # (redis, namespace?, func, input) ?
  got = redis.get(input)
  if got
    return got
  else
    result = func.call(input)
    redis.set(input, result)
    return result
  end
end

def fibonacci (n)
  return n if n <= 1
  fibonacci(n - 1) + fibonacci(n - 2)
end

def memo_fib (n)
  memo($redis, ->(n){ fibonacci(n) }, n)
end

#puts fibonacci(30)
puts memo_fib(37)

