# $environment = :dev
$environment = :prod

module Panopticon
  def self.daemonize(config = nil)
    if config.nil?
      File.delete('./panopticon_temp') if File.exists?('./panopticon_temp')
      exec "god -c lib/god.rb -l ./log/daemon.log -P ./log/panopticon.pid"
    else
      make_temp_file(config)
      exec "god -c lib/god.rb -l ./log/daemon.log -P ./log/panopticon.pid"
    end
  end

  def self.console(config = nil)
    if config.nil?
      tempfile = './panopticon_temp'
      File.delete(tempfile) if File.exists?(tempfile)
      exec "god -c lib/god.rb -D"
    else
      make_temp_file(config)
      exec "god -c lib/god.rb -D"
    end
  end

  def self.stop(config = nil)
    exec "god quit"
  end

  def self.make_temp_file(contents)
    IO.write('panopticon_temp', contents)
  end
end

require './lib/panopticon/monitor'
require './lib/panopticon/dsl'
