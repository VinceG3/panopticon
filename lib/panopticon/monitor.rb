module Panopticon
  class Monitor
    attr_reader :project_name
    @monitors = []

    def initialize(project_name, options)
      @project_name = project_name
      @start_command = options[:start_command]
      @stop_command = options[:stop_command]
    end

    def environment
      return :prod if ENV["USER"] == "deploy" or ENV["USER"].nil?
      return :dev
    end

    def directory
      case environment
      when :dev
        File.join('/', 'home', ENV["USER"], 'src', project_name)
      when :prod
        File.join('/', 'home', 'deploy', project_name, "current")
      end
    end

    def self.add(monitor)
      @monitors << monitor
    end

    def check
      return start unless pidfile?
      return restart unless process?
    end

    def start
      system(start_command)
    end

    def start_command
      "( cd #{directory} && bin/#{project_name} #{@start_command} )"
    end

    def restart
      remove_pidfile
      start
    end

    def remove_pidfile
      binding.pry
    end

    def pidfile?
      File.exists?(pidfile_path)
    end

    def pidfile_path
      File.join(directory, 'log', "#{@project_name}.pid")
    end

    def process_id
      IO.read(pidfile_path).chomp
    end

    def process?
      !!process_id
    end

    def self.watch
      loop do
        @monitors.each(&:check)
        sleep 5
      end
    end
  end
end

    # def watch_god
    #   God.watch do |w|
    #     w.name = project_name
    #     w.start = start_command
    #     w.stop = stop_command
    #     w.restart = start_command
    #     w.pid_file = pid_file
    #     w.log = log_file
    #     w.dir = directory

    #     w.interval        = 30.seconds
    #     w.start_grace     = 15.seconds
    #     w.restart_grace   = 15.seconds
    #     w.behavior(:clean_pid_file)

    #     w.start_if do |start|
    #       start.condition(:process_running) do |c|
    #         c.interval = 5.seconds
    #         c.running = false
    #       end
    #     end
    #   end
    # end
