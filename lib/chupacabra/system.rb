require 'base64'

module Chupacabra
  module System
    extend self

    def get_password
      return get_env_password if get_env_password
      password = get_password_from_dialog
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
      run_script(
        <<-EOS
          tell application "System Events"
            return name of first application process whose frontmost is true
          end tell
        EOS
      )
    end

    def get_browser_url
      run_script(
        case front_app
          when 'Google Chrome', 'Google Chrome Canary'
            'tell application "#{front_app}" to return URL of active tab of front window'
          when 'Camino'
            'tell application "#{front_app}" to return URL of current tab of front browser window'
          when 'Safari', 'Webkit', 'Opera'
            'tell application "#{front_app}" to return URL of front document'
          else
            <<-EOS
              tell application "System Events"
                keystroke "l" using command down
                keystroke "c" using command down
              end tell
              delay 0.1
              return the clipboard
            EOS
        end
      )
    end

    def alert(message)
      run_script(
        <<-EOS
          tell application "#{front_app}"
            activate
            display alert "#{message}" as warning
          end tell
        EOS
      )
    end

    private

    def run_script(script)
      raise ArgumentError, "Script can't contain single quotes" if script =~ /'/
      `osascript #{script.split("\n").collect{|line| " -e '#{line.strip}'"}.join}`.strip
    end

    def password_variable
      Chupacabra.test? ? 'CHUPACABRA' : 'CHUPACABRA_TEST'
    end

    def get_password_from_dialog
      strip_dialog_response(ask_for_password)
    end

    def strip_dialog_response(response)
      response.match(/text returned:(.+), button returned:OK/)[1]
    end

    def ask_for_password
      dialog = 'display dialog "Enter Chupacabra password"' +
        'default answer ""' +
        'with title "Chupacabra"' +
        'with icon caution with hidden answer'

      script = <<-EOS
        tell application "#{front_app}"
          activate
          #{dialog}
        end tell
      EOS

      run_script(script)
    end

    def get_env_password
      password64 = `launchctl getenv #{password_variable}`.strip
      return if password64.empty?
      Base64.decode64(password64).strip
    end

    def set_env_password(password)
      `launchctl setenv #{password_variable} '#{Base64.encode64(password).strip}'`
    end
  end
end