require_relative '../spec_helper'

describe Mumble::Server do
  let(:options) { { username: 'test' }  }
  subject { Mumble::Server.new 'localhost', 64738, options }

  describe 'initialization' do
    its(:host) { is_expected.to eq 'localhost' }
    its(:port) { is_expected.to_not be_nil }
    its(:options) { is_expected.to be_kind_of Hash }
    its(:channels) { is_expected.to be_kind_of Array }

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

      allow(EM).to receive :add_periodic_timer
    end

    it 'should send version information' do
      expect(subject).to receive :send_version

      subject.connection_completed
    end

    it 'should send authentication' do
      expect(subject).to receive :authenticate

      subject.connection_completed
    end

    it 'should create a periodic timer for pings' do
      expect(EM).to receive :add_periodic_timer

      subject.connection_completed
    end
  end

  describe '#receive_message' do
    context 'when the message is a ChannelState' do
      let(:channel_state) do
        Mumble::Messages::ChannelState.new
      end

      it 'should handle the message' do
        expect(subject).to receive :receive_channel_state

        subject.receive_message channel_state
      end
    end
  end

  describe '#receive_channel_state' do
    let(:channel) { double(:channel).as_null_object }
    let(:channel_state) { double(id: 1).as_null_object }

    before :each do

    end

    it 'should see if the channel is recognized' do
      expect(subject).to receive :channel_by_id

      subject.receive_channel_state channel_state
    end

    context 'when the channel is recognized' do
      before { allow(subject).to receive(:channel_by_id).and_return channel }

      it 'should synchronize the channel' do
        expect(channel).to receive :synchronize

        subject.receive_channel_state channel_state
      end
    end

    context 'when the channel is new' do
      pending
    end
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
