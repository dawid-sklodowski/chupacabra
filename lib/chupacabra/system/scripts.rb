module Chupacabra
  module System
    module Scripts
      extend self

      BROWSERS = ['Google Chrome', 'Google Chrome Canary', 'Camino', 'Safari', 'Webkit', 'Opera']

      def front_app
        <<-EOS
          tell application "System Events"
            return name of first application process whose frontmost is true
          end tell
        EOS
      end

      def get_browser_url(app)
        return unless BROWSERS.include?(app)
        case app
          when 'Google Chrome', 'Google Chrome Canary'
            %Q(tell application "#{app}" to return URL of active tab of front window)
          when 'Camino'
            %Q(tell application "#{app}" to return URL of current tab of front browser window)
          when 'Safari', 'Webkit', 'Opera'
            %Q(tell application "#{app}" to return URL of front document)
          when 'firefox'
            <<-EOS
              tell application "System Events"
                keystroke "l" using command down
                keystroke "c" using command down
              end tell
              delay 0.1
              return the clipboard
            EOS
        end
      end

      def paste_clipboard
        'tell application "System Events" to keystroke "v" using command down'
      end

      def alert(app, message)
        <<-EOS
          tell application "#{app}"
            activate
            display alert "#{message}" as warning
          end tell
        EOS
      end

      def ask_for_password(app)
        dialog = 'display dialog "Enter Chupacabra password"' +
                 'default answer ""' +
                 'with title "Chupacabra"' +
                 'with icon caution with hidden answer'

        <<-EOS
          tell application "#{app}"
            activate
            #{dialog}
          end tell
        EOS

      end
    end
  end
end