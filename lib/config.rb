require "yaml"
require "ostruct"

def config
  @value ||= begin
               root = YAML.load_file("./config.yml")
               redis = OpenStruct.new(root["redis"])
               new_root = OpenStruct.new("redis" => redis)
               new_root
             end
end

=begin USAGE
puts config.redis.host
puts config.redis.port
=end
  