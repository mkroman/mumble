# encoding: utf-8
require_relative '../spec_helper'

describe Mumble::Channel do
  subject { Mumble::Channel.new 1, 'Test' }

  describe 'default attributes' do
    it 'should have an id' do
      expect(subject.id).to be_kind_of Integer
    end

    it 'should have a name' do
      expect(subject.name).to be_kind_of String
    end

    it 'should not be temporary' do
      expect(subject.temporary).to be false
    end

    it 'should not have a description' do
      expect(subject.description).to be_nil
    end

    it 'should not have a parent id' do
      expect(subject.parent_id).to be_nil
    end

    it 'should have a position of 0' do
      expect(subject.position).to eq 0
    end
  end

  describe '#temporary?' do
    it 'should return the temporary flag' do
      expect(subject.temporary?).to eq subject.temporary
    end
  end

  describe '#synchronize' do
    let(:channel_state) { double(:channel_state, name: 'abc', temporary: true) }

    it 'should set the channel name' do
      expect(channel_state).to receive :name

      subject.synchronize channel_state

      expect(subject.name).to eq channel_state.name
    end

    it 'should set the temporary flag' do
      subject.synchronize channel_state

      expect(subject.temporary).to eq channel_state.temporary
    end
  end
end
