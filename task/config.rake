#!/usr/bin/env ruby
# callowaylc@gmail.com
# Provides rsa key-file symmetric encryption of secrets

namespace :config do

  desc "creates public/private key-pair and pem"
  task :keys do
    exec %{
      name=contact-email-crawler
      rm -rf /tmp/$name
      (
        ssh-keygen \
          -f  /tmp/$name \
          -t rsa -N '' && \
        openssl rsa \
          -in /tmp/$name \
          -outform PEM \
          -pubout \
          -out ~/.ssh/$name.public.pem && \
        openssl rsa \
          -in /tmp/$name \
          -outform PEM \
          -out ~/.ssh/$name.private.pem
      ) > /dev/null 2>&1
      ls -lhat ~/.ssh/$name*
    }
  end

  desc "encrypt config"
  task :encrypt do
    command %{
      rm -rf #{ home }/.stack/*
      key="#{ home }/.stack/key"
      openssl rand -base64 128 -out $key

      find #{ home }/stack -name '*.yml' | while read file
        do
          path=`echo $file | sed 's/stack/.stack/'`
          mkdir -p `dirname $path` > /dev/null 2>&1
          cat $file | openssl \
            enc \
            -aes-256-cbc \
            -salt \
            -pass file:$key > $path
      done

      # finally encrypt key file
      cat $key | openssl \
        rsautl \
        -encrypt \
        -inkey ~/.ssh/salt.public.pem \
        -pubin > $key.encrypted

      rm $key
    }
  end

  desc "decrypt config"
  task :decrypt do
    command %{
      rm -rf #{ home }/stack
      key="#{ home }/.stack/key"
      cat $key.encrypted | openssl \
        rsautl \
        -decrypt \
        -inkey ~/.ssh/salt.private.pem \
          > $key

      find #{ home }/.stack -name '*.yml' | while read file
        do
          path=`echo $file | sed 's/.stack/stack/'`
          mkdir -p `dirname $path` > /dev/null 2>&1
          cat $file | openssl \
            enc \
            -d \
            -aes-256-cbc \
            -pass file:$key > $path
      done

      rm $key
    }
  end
end
