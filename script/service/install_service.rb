require "win32/service"
include Win32
class String; def to_dos() self.tr('/','\\') end end
class String; def from_dos() self.tr('\\','/') end end
#override to support utf8
class String; def strip() self end end


ROOT_PATH = File.expand_path('../../../../') 
RUBY_PATH = "#{ROOT_PATH}/ruby200/bin/ruby.exe"
rubyexe=RUBY_PATH.to_dos
SERVICE_FILE= (File.expand_path(File.dirname(__FILE__))+ '/run_all.rb').to_dos
SERVICE_NAME="Estatee"

if ARGV[0]
  case ARGV[0] 
  when "install" 
    puts "#{rubyexe} #{SERVICE_FILE}"
    Service.new(
      :service_name     => SERVICE_NAME, 
      :service_type       => Service::WIN32_OWN_PROCESS,
      :start_type         => Service::AUTO_START,
      :error_control      => Service::ERROR_NORMAL,
      :binary_path_name   => "#{rubyexe} #{SERVICE_FILE}",
      :description       => 'Run  nginx, ruby all in one'
   )
  when "uninstall"  
    Service.delete(SERVICE_NAME)
  end
end