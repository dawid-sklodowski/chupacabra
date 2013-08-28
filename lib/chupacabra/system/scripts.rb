module Chupacabra
  module System
    module Scripts
      extend self

      def compile_all
        [:front_app, :get_browser_url, :paste_clipboard, :alert, :ask_for_password].each do |script|
          compile(script)
        end
      end

      def compile(script)
        `osacompile -e '#{self.send(script)}' -o #{script_path(script)}`
      end

      def front_app
        <<-SCPT
          tell application "System Events"
            return name of first application process whose frontmost is true
          end tell
        SCPT
      end

      # Script requires argument: application name
      def get_browser_url
        <<-SCPT
          on run argv
            set _browser to item 1 of argv
            if ({ "Google Chrome", "Google Chrome Canary" } contains _browser) then
              tell application _browser to return URL of active tab of front window
            else if (_browser = "Camino") then
              tell application _browser to return URL of current tab of front _browser window
            else if (_browser is contained by { "Safari", "Webkit", "Opera" }) then
              tell application _browser to return URL of front document
            else if (_browser = "firefox") then
              tell application "System Events"
                keystroke "l" using command down
                keystroke "c" using command down
              end tell
              delay 0.1
              return the clipboard
            end if
          end run
        SCPT
      end

      def paste_clipboard
        <<-SCPT
          tell application "System Events" to keystroke "v" using command down
        SCPT
      end

      # Script requires two arguments: application name, message
      def alert
        <<-SCPT
          on run argv
            set _application to item 1 of argv
            set _message to item 2 of argv
            tell application _application
              activate
              display alert _message as warning
            end tell
          end run
        SCPT
      end

      # Script requires argument: application name
      def ask_for_password
        <<-SCPT
          on run argv
            set _application to item 1 of argv
            tell application _application
              activate
              display dialog "Enter Chupacabra password" default answer "" with title "Chupacabra password" with icon caution with hidden answer
            end tell
          end run
        SCPT
      end

      private

      def script_path(script)
        Chupacabra.root + 'osx' + 'apple_scripts' + "#{script}.scpt"
      end
    end
  end
end