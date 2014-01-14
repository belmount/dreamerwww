require 'win32/daemon'
include Win32
class String; def to_dos() self.tr('/','\\') end end

ROOT_PATH = 'e:/standalone'
SERVICE_LOG = "#{ROOT_PATH}/logs/services.log"
RUBY_LOG = "#{ROOT_PATH}/logs/ruby.log"
SINATRA_LOG = "#{ROOT_PATH}/logs/sinatra.log"
RUBY_PATH = "#{ROOT_PATH}/ruby200/bin"
NGINX_HOME = "#{ROOT_PATH}/nginx"
APP_HOME = "#{ROOT_PATH}/www/estatee"
API_SCRIPT = "#{APP_HOME}/script/service/new_agency_pub.rb"
BUNDLE_PATH = "#{APP_HOME}/script/service"

class Daemon
  def service_main
     while running?
        if @pid.nil?
          @pid = Process.spawn("#{NGINX_HOME}/nginx.exe".to_dos, 
           chdir: NGINX_HOME,
           out: SERVICE_LOG, err: :out)

          Process.detach @pid
          if @pid_ruby.nil?
            @pid_ruby = []
            start_thin
          end
         
          Process.waitpid(@pid)
        else 
          sleep(3)
        end
     end
  end

  def service_stop
     if @pid
        pid_kill = Process.spawn("#{NGINX_HOME}\\nginx.exe -s stop".to_dos,
            chdir: NGINX_HOME, 
            out: SERVICE_LOG, err: :out)
          Process.waitpid(pid_kill)
     end
     if @pid_ruby.size > 0 
       @pid_ruby.each do |pid| 
          pid_kill = Process.kill(9, pid)
       end
     end 
  end

  def start_thin
    if @pid_ruby.empty?

      [3000, 4000].each do |port|
        cmd = "#{RUBY_PATH}\\setrbvars.bat & bundle exec thin start -p #{port} -e production".to_dos
        pid =  Process.spawn(cmd, chdir: APP_HOME ,out:RUBY_LOG, err: :out)
        @pid_ruby << pid
        Process.detach pid
      end

      cmd = "#{RUBY_PATH}\\ruby.exe #{API_SCRIPT}".to_dos
      pid =  Process.spawn(cmd, chdir: APP_HOME ,out:RUBY_LOG, err: :out)
      @pid_ruby << pid
      Process.detach pid
    end
  end

end

#d = Daemon.new
#d.service_main
Daemon.mainloop
