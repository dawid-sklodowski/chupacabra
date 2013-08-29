module Chupacabra
  module System
    module Install
      extend self

      def install
        handle_legacy_file
        install_service
        Chupacabra::System::Scripts.compile_all
        update_version
      end

      def uninstall
        FileUtils.rm_rf user_service_path
      end

      private

      def install_service
        user_service_contents = user_service_path + 'Contents'
        user_service_contents.mkpath unless user_service_contents.exist?
        chupacabra_service_contents = Chupacabra.root + 'osx' + 'Chupacabra.workflow' + 'Contents'
        %w(document.wflow Info.plist).each do |filename|
          (user_service_contents + filename).open('w') do |file|
            file << (chupacabra_service_contents + filename).read
          end
        end
      end

      def user_service_path
        if Chupacabra.test?
          Pathname.new(ENV['HOME']) + 'Library/Services/Chupacabra_test.workflow'
        else
          Pathname.new(ENV['HOME']) + 'Library/Services/Chupacabra.workflow'
        end
      end

      def handle_legacy_file
        legacy_passwords_file = Pathname.new(ENV['HOME']) + '.chupacabra'
        return unless legacy_passwords_file.file?
        temporary_passwords_file = Pathname.new(ENV['HOME'] + '.chupacabra_tmp')
        legacy_passwords_file.rename(temporary_passwords_file)
        temporary_passwords_file.rename(Chupacabra::Storage.passwords_path)
      end

      def update_version
        Chupacabra::Storage.version_path.open('w') { |file| file << Chupacabra::VERSION }
      end
    end
  end
end