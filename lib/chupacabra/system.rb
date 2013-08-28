require 'base64'
require 'digest'
require 'pathname'
require 'fileutils'
require 'chupacabra/system/scripts'

module Chupacabra
  module System
    extend self

    BROWSERS = ['Google Chrome', 'Google Chrome Canary', 'Camino', 'Safari', 'Webkit', 'Opera', 'Firefox']

    def get_password
      return get_env_password unless get_env_password.empty?
      password = Digest::SHA1.hexdigest(get_password_from_dialog)
      raise "Password can't be empty" if !password || password.empty?
      set_env_password(password)
      password
    end

    def clear
      `launchctl unsetenv #{password_variable}` if osx?
    end

    def get_clipboard
      `pbpaste`.strip
    end

    def set_clipboard(text)
      raise 'Unsupported string' if text =~ /'/
      `echo '#{text}' | pbcopy`
    end

    def osx?
      `uname`.strip == 'Darwin'
    end

    def linux?
      `uname`.strip == 'Linux'
    end

    def front_app
      run_script(Scripts.front_app)
    end

    def get_browser_url
      app = front_app
      return unless BROWSERS.include?(app)
      run_script(Scripts.get_browser_url(app))
    end

    def paste_clipboard
      run_script(System.paste_clipboard)
    end

    def alert(message)
      run_script(Scripts.alert(front_app, message))
    end

    def install
      user_service_contents = user_service_path + 'Contents'
      user_service_contents.mkpath unless user_service_contents.exist?
      chupacabra_service_contents = Pathname.new(
        File.expand_path('../../../osx/Chupacabra.workflow/Contents', __FILE__)
      )

      %w(document.wflow Info.plist).each do |filename|
        (user_service_contents + filename).open('w') do |file|
          file << (chupacabra_service_contents + filename).read
        end
      end
    end

    def uninstall
      FileUtils.rm_rf user_service_path
    end

    def user_service_path
      if Chupacabra.test?
        Pathname.new(ENV['HOME']) + 'Library/Services/Chupacabra_test.workflow'
      else
        Pathname.new(ENV['HOME']) + 'Library/Services/Chupacabra.workflow'
      end
    end

    def log(message)
      return unless Chupacabra.log
      log_path.open('a') do |file|
        file << message
        file << "\n"
      end
      message
    end

    def log_path
      if Chupacabra.test?
        (Chupacabra.root + 'log' + 'chupacabra.log')
      else
        (Pathname.new(ENV['HOME']) + 'chupacabra.log')
      end
    end

    private

    def run_script(script)
      return unless script
      raise ArgumentError, "Script can't contain single quotes" if script =~ /'/
      return if Chupacabra.test? or !Chupacabra.osx?
      `osascript #{script.split("\n").collect{|line| " -e '#{line.strip}'"}.join}`.strip
    end

    def password_variable
      Chupacabra.test? ? 'CHUPACABRA_TEST' : 'CHUPACABRA'
    end

    def get_password_from_dialog
      strip_dialog_response(ask_for_password)
    end

    def strip_dialog_response(response)
      response.match(/text returned:(.+), button returned:OK/)[1]
    end

    def ask_for_password
      run_script(Scripts.ask_for_password(front_app))
    end

    def get_env_password
      `launchctl getenv #{password_variable}`.strip
    end

    def set_env_password(password)
      `launchctl setenv #{password_variable} '#{password}'`
    end
  end
end