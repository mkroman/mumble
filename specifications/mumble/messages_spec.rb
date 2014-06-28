require_relative '../spec_helper'

describe Mumble::Messages do
  it "has a list of message types" do
    expect(Mumble::Messages.const_get(:MessageTypes)).to be_kind_of Hash
  end

  it "has a list of message aliases" do
    expect(Mumble::Messages.const_get(:MessageAliases)).to be_kind_of Hash
  end

  describe ".alias_for" do
    it "returns an alias" do
      version_alias = Mumble::Messages.alias_for Mumble::Messages::Version

      expect(version_alias).to_not be_nil
      expect(version_alias).to be_kind_of Symbol
    end
  end

  describe ".class_for" do
    it "returns a class" do
      version_class = Mumble::Messages.class_for 0

      expect(version_class).to eq Mumble::Messages::Version
    end
  end
end
