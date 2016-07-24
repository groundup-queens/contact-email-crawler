require "yaml"
require "ostruct"

class Config
  def initialize (file)
    @file = file
  end
  def load
    root = YAML.load_file(@file)
    redis = OpenStruct.new(root["redis"])
    new_root = OpenStruct.new("redis" => redis)
    new_root
  end
end

=begin USAGE
config = Config.new("../config.yml").load
puts config.redis.host
puts config.redis.port
=end
  