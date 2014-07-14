require_relative '../spec_helper'

describe Mumble::Messages do
  it 'should have a mapping of types to classes' do
    expect(Mumble::Messages.const_get(:MessageTypesToClasses)).to be_kind_of Hash
  end

  it 'should have a mapping of classes to types' do
    expect(Mumble::Messages.const_get(:MessageClassesToTypes)).to be_kind_of Hash
  end

  it 'should have a mapping of type aliases' do
    expect(Mumble::Messages.const_get(:MessageAliases)).to be_kind_of Hash
  end

  describe ".alias_for_message" do
    context 'when there is an alias' do
      before do
        stub_const 'Mumble::Messages::MessageAliases', { Class => :an_alias }
      end

      it 'should return a symbol' do
        result = Mumble::Messages.alias_for_message Class

        expect(result).to be :an_alias
      end
    end

    context 'when there is no alias' do
      it 'should raise an error'
    end
  end

  describe '.class_for_message' do
    context 'when there is a class' do
      it 'should return a class'
    end
    
    context 'when there is no class' do
      it 'should raise an error'
    end

    it "should return a message class" do
      version_class = Mumble::Messages.class_for_message 0

      expect(version_class).to eq Mumble::Messages::Version
    end
  end
end
