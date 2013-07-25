
module Chupacabra
  def ask_for_password
    dialog = 'display dialog "Enter Chupacabra password"' +
             'default answer ""' +
             'with title "Chupacabra"' +
             'with icon caution with hidden answer'

    run_command(%Q{osascript -e 'tell application "Finder"' -e "activate"  -e '#{dialog}' -e 'end tell'})
  end

  private

  def run_command(command)
    `#{command}`
  end


end

require 'chupacabra/system'
require 'pry'
require 'base64'