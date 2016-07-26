#!/usr/bin/env ruby
# callowaylc@gmail.com
# Provides set of tasks that act as interface to redis instance

namespace :redis do

  desc "run redis container"
  task :run do
    exec %{
      image='redis:3.0.7'
      path=/usr/local/etc/redis/redis.conf

      (
        sudo docker pull $image
        sudo docker rm -f redis-0
        rake config:decrypt
      ) > /dev/null 2>&1

      # get password from config; parse config yaml into
      # key=value expressions which will place password into
      # current context. Next we eval redis.conf file, interpolate
      # password and write to docker path
      eval `sed -e 's/:[^:\/\/]/="/g;s/$/"/g;s/ *=/=/g' \
        ./config.yml | tail -n +2`
      config=$(
        eval "echo \"`cat ./usr/local/etc/redis/redis.conf | sed -e '/^#/d'`\""
      )

      # move redis.conf to docker mounted directory
      sudo mkdir -p /docker/redis-0/`dirname $path`
      echo "$config" > /docker/redis-0/$path

      sudo docker run \
        -d \
        --name=redis-0 \
        --volume="/docker/redis-0/$path:$path" \
        --publish="0.0.0.0:9736:6379" \
          $image redis-server $path
    }
  end
end
