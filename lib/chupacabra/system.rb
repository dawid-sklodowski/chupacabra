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

    private

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

      `osascript -e 'tell application "Finder"' -e "activate"  -e '#{dialog}' -e 'end tell'`
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