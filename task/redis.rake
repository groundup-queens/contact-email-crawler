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
      ) > /dev/null 2>&1

      # move redis.conf to docker mounted directory
      sudo mkdir -p /docker/redis-0/`basename $path`
      sudo cp ./$path /docker/redis-0/$path

      sudo docker run \
        -d \
        --name=redis-0 \
        --volume="/docker/redis-0/$path:$path" \
        --publish="0.0.0.0:9736:6379" \
          $image
    }
  end
end
