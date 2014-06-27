require_relative '../spec_helper'

describe Mumble do
  it "should have a version constant" do
    expect(Mumble.const_get(:Version)).to be_kind_of String
  end

  describe ".version" do
    it "should return the version constant" do
      expect(Mumble.version).to eq Mumble::Version
    end
  end
end
