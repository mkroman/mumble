require_relative '../spec_helper'

describe Mumble::Client do
  describe "initialize" do
    it "has options" do
      expect(subject.options).to be_kind_of Hash
    end

    it "has a connection" do
      expect(subject).to be_instance_variable_defined :@connection
    end
  end

  describe "#run" do
    it "starts the eventmachine loop" do
      expect(EM).to receive :run

      subject.connect
    end
  end
end
