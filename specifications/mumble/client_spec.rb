require_relative '../spec_helper'

describe Mumble::Client do
  describe "initialize" do
    it "should have options" do
      expect(subject.options).to be_kind_of Hash
    end
  end

  describe "#run" do
    it "should start the eventmachine loop" do
      expect(EM).to receive :run

      subject.connect
    end
  end
end
