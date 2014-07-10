require_relative '../spec_helper'

RSpec::Matchers.define :send_message do |expected|
  a
end

describe Mumble::Server do
  let(:options) { { username: 'test' }  }
  subject { Mumble::Server.new 'localhost', 64738, options }

  describe 'initialization' do
    its(:host) { is_expected.to eq 'localhost' }
    its(:port) { is_expected.to_not be_nil }
    its(:options) { is_expected.to be_kind_of Hash }

    context 'when there is no username in :options' do
      it 'should raise an error' do
        expect { Mumble::Server.new 'localhost' }.to raise_error
      end
    end

    context 'when there is username in :options' do
      it 'should not raise an error' do
        expect { Mumble::Server.new 'localhost', 64738, options }.to_not raise_error
      end
    end
  end

  describe '#connection_completed' do
    before :each do
      connection = double(:connection).as_null_object
      subject.connection = connection
    end
    it 'should send version information' do
      expect(subject).to receive :send_version

      subject.connection_completed
    end

    it 'should send authentication' do
      expect(subject).to receive :authenticate

      subject.connection_completed
    end
  end

  describe '#receive_message' do
    it 'should handle the message'
  end

  describe '#send_version' do
    before(:each) { subject.connection = double :connection }

    it 'should send the version message' do
      expect(subject.connection).to receive(:send_message).with Mumble::Messages::Version, anything

      subject.send_version
    end
  end

  describe '#authenticate' do
    before(:each) { subject.connection = double :connection }

    it 'should send the authenticate message' do
      expect(subject.connection).to receive(:send_message).with Mumble::Messages::Authenticate, anything

      subject.authenticate 'abc', 'def'
    end
  end
end
