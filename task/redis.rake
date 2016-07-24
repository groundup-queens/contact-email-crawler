#!/usr/bin/env ruby
# callowaylc@gmail.com
# Provides set of tasks that act as interface to redis instance

namespace :redis do

  desc "run redis container"
  task :run do
    exec %{
      image='redis:3.0.7'
      (
        sudo docker pull $image
        sudo docker rm -f redis-0
      ) > /dev/null 2>&1

      sudo docker run \
        -d \
        --name=redis-0 \
        --publish="0.0.0.0:9736:6379" \
          $image
    }
  end
end
