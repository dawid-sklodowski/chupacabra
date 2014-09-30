require 'base64'
require 'digest'
require 'pathname'
require 'fileutils'

module Chupacabra
  module System
    extend self

    class Error < Chupacabra::Error; end

    BROWSERS = ['Google Chrome', 'Google Chrome Canary', 'Camino', 'Safari', 'Webkit', 'Opera', 'Firefox']

    def execute(command, run_in_test = false)
      log(command)
      if Chupacabra.test? && !run_in_test
        `echo #{command}`
      else
        log(command)
        `#{command}`
      end.strip
    end

    def get_password
      return get_env_password unless get_env_password.empty?
      password = Digest::SHA1.hexdigest(get_password_from_dialog)
      raise "Password can't be empty" if !password || password.empty?
      set_env_password(password)
      password
    end

    def clear
      System.execute("launchctl unsetenv #{password_variable}", osx?)
    end

    def get_clipboard
      System.execute("pbpaste", osx?).strip
    end

    def set_clipboard(text)
      raise 'Unsupported string' if text =~ /'/
      System.execute("echo '#{text}' | pbcopy", osx?)
    end

    def osx?
      `uname`.strip == 'Darwin'
    end

    def linux?
      `uname`.strip == 'Linux'
    end

    def front_app
      run_script(:script => :front_app)
    end

    def get_browser_url
      app = front_app
      return unless BROWSERS.include?(app)
      run_script(:script => :get_browser_url, :compile_argument => app)
    end

    def paste_clipboard
      run_script(:script => :paste_clipboard)
    end

    def alert(message)
      run_script(:script => :alert, :arguments => [front_app, message])
    end

    def log(message, force = false)
      return unless Chupacabra.log || force
      log_path.open('a') do |file|
        file << message
        file << "\n"
      end
      message
   end

   def log_path
     Chupacabra::Storage.path + 'chupacabra.log'
   end

    private

    def run_script(options ={})
      return if Chupacabra.test? or !Chupacabra::System.osx?
      script = options.fetch(:script)
      compile_argument = options.fetch(:compile_argument, nil)
      arguments = options.fetch(:arguments) { [] }
      script_file = Chupacabra::System::Scripts.script_or_compile(script, compile_argument)
      script = "osascript #{script_file} #{arguments.collect{ |arg| "'" + arg + "'" }.join(' ') }"
      System.execute(script)
    end

    def password_variable
      Chupacabra.test? ? 'CHUPACABRA_TEST' : 'CHUPACABRA'
    end

    def get_password_from_dialog
      strip_dialog_response(ask_for_password)
    end

    def strip_dialog_response(response)
      System.log(response)
      response.match(/.class ttxt.:([^,]+)/)[1]
    end

    def ask_for_password
      run_script(:script => :ask_for_password, :arguments => [front_app])
    end

    def get_env_password
      System.execute("launchctl getenv #{password_variable}", osx?).strip
    end

    def set_env_password(password)
      System.execute("launchctl setenv #{password_variable} '#{password}'", osx?)
    end
  end
end
