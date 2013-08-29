require 'spec_helper'

describe Chupacabra::System::Install do

  describe 'uninstall' do
    before do
      Chupacabra::System::Install.install
    end

    it 'deletes service directory' do
      Chupacabra::System.user_service_path.should be_exist
      Chupacabra::System.uninstall
      Chupacabra::System.user_service_path.should_not be_exist
    end
  end
end