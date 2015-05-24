module Panopticon
  class Dsl
    attr_reader :file
    def initialize(file)
      @file = file
    end

    def self.parse(file = './Panopticonfile')
      new(file).parse
    end

    def parse
      instance_eval(IO.read(file))
      puts "No monitors found!" if Monitor.empty?
    end

    def watch(project, options = {})
      @hosts = options[:on]
      if watch_on_this_host?
        puts "Found #{project}"
        Monitor.add(Monitor.new(project, options))
      end
    end

    private

      def watch_on_this_host?
        return true unless ENV["USER"] == "deploy"
        return true if @hosts.include?(`hostname`.chomp)
        return false
      end
  end
end