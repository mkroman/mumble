require_relative '../spec_helper'

describe Mumble::Connection do
  describe "#post_init" do
    subject { Mumble::Connection.allocate }

    it "should start a TLSv1 session" do
      expect(subject).to receive(:start_tls){|arg| expect(arg).to include ssl_version: :TLSv1 }

      subject.post_init
    end
  end
end
