module Chupacabra
  module System
    module Scripts
      extend self

      def compile_all
        clear_scripts
        [:front_app, :paste_clipboard, :alert, :ask_for_password].each do |script|
          compile(script)
        end
        Chupacabra::System::BROWSERS.each do |browser|
          compile(:get_browser_url, browser)
        end
      end

      def compile(script, argument = nil)
        `osacompile -e '#{self.send(*[script, argument].compact)}' -o #{script_file(script, argument)}`
        if $?.success?
          return script_file(script, argument)
        else
          puts "Failed to compile: #{script_file(script, argument)}"
          nil
        end
      end

      def script_file(script, argument = nil)
        argument = '_' + argument.downcase.gsub(/ /, '_') if argument
        scripts_path + "#{script}#{argument}.scpt"
      end

      def script_or_compile(script, argument = nil)
        return script_file(script, argument) if File.exist?(script_file(script, argument))
        compile(script, argument) or raise "Can't compile #{script}#{' with arugment' + argument if argument}"
      end

      def front_app
        <<-SCPT
          tell application "System Events"
            return name of first application process whose frontmost is true
          end tell
        SCPT
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
          when 'Firefox'
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

      def scripts_path
        Chupacabra.root + 'osx' + 'apple_scripts'
      end

      def clear_scripts
        Dir.glob(scripts_path + '*').each{ |file| Pathname.new(file).delete }
      end
    end
  end
end