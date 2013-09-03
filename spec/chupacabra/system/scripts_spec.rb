require 'spec_helper'

describe Chupacabra::System::Scripts do
  let(:file_path) { Chupacabra.root + 'tmp' + '.chupacabra' + 'apple_scripts' + 'get_browser_url_google_chrome.scpt' }

  before do
    file_path.dirname.mkpath unless file_path.dirname.exist?
  end

  after do
    file_path.delete if file_path.exist?
  end

  describe '.compile' do
    subject { described_class.compile(:get_browser_url, 'Google Chrome') }
    it 'executes script to compile' do
      subject.should.to_s =~ /osacompile -e 'tell application \"Google Chrome\" to return URL of active tab of front window' -o .*get_browser_url_google_chrome.scpt/
    end
  end

  describe '.compile_all' do
    it 'compiles all scripts' do
      described_class.should_receive(:compile).exactly(11)
      described_class.compile_all
    end
  end

  describe 'script_or_compile' do
    subject { described_class.script_or_compile(:get_browser_url, 'Google Chrome') }

    it 'returns file path if file exists' do
      file_path.open('w') { |file| file << 'This is Warsaw!' }
      described_class.should_not_receive(:compile)
      subject.should == file_path
    end

    it 'compiles script if file does not exist' do
      described_class.should_receive(:compile).and_return(true)
      subject.should == file_path
    end
  end
end