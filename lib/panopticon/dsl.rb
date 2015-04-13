module Panopticon
  class Dsl
    attr_reader :file
    def initialize(file)
      @file = file
    end

    def self.parse(file = './Panopticonfile')
      if File.exists?('./panopticon_temp')
        new('./panopticon_temp').parse
      else
        new(file).parse
      end
    end

    def parse
      instance_eval(IO.read(file))
    end

    def watch(project, options = {})
      @hosts = options[:on]
      Monitor.new(project).watch if watch_on_this_host?
    end

    private

      def watch_on_this_host?
        return true unless ENV["USER"] == "deploy"
        return true if @hosts.include?(`hostname`.chomp)
        return false
      end
  end
end