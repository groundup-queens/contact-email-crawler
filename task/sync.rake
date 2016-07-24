#!/usr/bin/env ruby
# callowaylc@gmail.com
# Provides fswatch/rsync combination to provide seamless sync to
# remote environment

desc "sync to remote environment"
task :sync, [ :remote ] do | t, arguments |
  command  %{
    key=__contact-email-crawler__
    brew install fswatch > /dev/null 2>&1

    # kill any previous fsync processes attached to this sync
    pkill -9 -f $key

    # below isnt working in rake context.. falling back
    # to ruby solution
    #path=`pwd`
    #repository=${path/$HOME/\~}
    repository="#{ home.sub ENV['HOME'], '~' }"
      fsync ./ #{ arguments[:remote] }:$repository $key \
        > /tmp/sync.`basename $repository`.log 2>&1 &
  }
end