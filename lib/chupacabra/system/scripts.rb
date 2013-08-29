module Chupacabra
  module System
    module Scripts
      extend self

      class Error < Chupacabra::System::Error; end

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
        script_body = self.send(*[script, argument].compact)
        raise Error, 'Empty script to compile' if script_body.empty?
        output = System.execute "osacompile -e '#{script_body}' -o #{script_file(script, argument)}"
        if $?.success?
          output
        else
          puts "Failed to compile: #{script_file(script, argument)}"
          puts output
          nil
        end
      end

      def script_or_compile(script, argument = nil)
        file = script_file(script, argument)
        return file if File.exist?(file)
        compile(script, argument) or raise "Can't compile #{script}#{' with argument ' + argument if argument}"
        file
      end

      private

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
          else
            raise Error, "Uknown browser: #{app}"
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

      def script_file(script, argument = nil)
        argument = '_' + argument.downcase.gsub(/ /, '_') if argument
        scripts_path + "#{script}#{argument}.scpt"
      end

      def scripts_path
        Chupacabra.root + 'osx' + 'apple_scripts'
      end

      def clear_scripts
        Dir.glob(scripts_path + '*').each{ |file| Pathname.new(file).delete }
      end
    end
  end
end