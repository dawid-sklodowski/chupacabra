require 'spec_helper'
require 'pathname'

describe Chupacabra::System::Install do
  let(:user_service_path) { Chupacabra.root + 'tmp' + 'Library' + 'Services' + 'Chupacabra.workflow' }

  describe 'uninstall' do
    before do
      Chupacabra::System::Install.install
    end

    it 'deletes service directory' do
      user_service_path.should be_exist
      Chupacabra::System::Install.uninstall
      user_service_path.should_not be_exist
    end

    it 'removes chupacabra settings' do
      Chupacabra::System::Install.uninstall
      (Chupacabra.root + 'tmp' + '.chupacabra').should_not be_exist
    end
  end

  describe 'install' do
    before do
      Chupacabra::System::Install.uninstall
    end

    after do
      Chupacabra::System::Install.uninstall
    end

    it 'creates service directory' do
      user_service_path.should_not be_exist
      Chupacabra::System::Install.install
      user_service_path.should be_exist
    end

    it 'compiles scripts' do
      Chupacabra::System::Scripts.should_receive(:compile_all)
      Chupacabra::System::Install.install
    end

    it 'updates version' do
      Chupacabra::System::Install.install
      (Chupacabra.root + 'tmp' + '.chupacabra' + 'version').read.should == Chupacabra::VERSION
    end
  end
end