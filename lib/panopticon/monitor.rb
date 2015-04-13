module Panopticon
  class Monitor
    attr_reader :project_name

    def initialize(project_name)
      @project_name = project_name
      @stop_command = stop_command
      @pid_file = pid_file
      @log_file = log_file
    end

    def executable
      File.join("bin", project_name)
    end

    def start_command
      "#{executable} daemon"
    end

    def stop_command
      "#{executable} stop"
    end

    def pid_file
      File.join(directory, "log", "#{project_name}.pid")
    end

    def log_file
      File.join(directory, "log", "#{project_name}.log")
    end

    def environment
      return :prod if ENV["USER"] == "deploy"
      return :dev
    end

    def directory
      case environment
      when :dev
        File.join('/', 'home', 'vince', 'src', project_name)
      when :prod
        File.join('/', 'home', 'deploy', project_name, "current")
      end
    end

    def watch
      God.watch do |w|
        w.name = project_name
        w.start = start_command
        w.stop = stop_command
        w.restart = start_command
        w.pid_file = pid_file
        w.log = log_file
        w.dir = directory

        w.interval        = 30.seconds
        w.start_grace     = 15.seconds
        w.restart_grace   = 15.seconds
        w.behavior(:clean_pid_file)

        w.start_if do |start|
          start.condition(:process_running) do |c|
            c.interval = 5.seconds
            c.running = false
          end
        end
      end
    end
  end
end