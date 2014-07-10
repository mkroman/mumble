require_relative '../spec_helper'

describe Mumble::Connection do
  let(:cert_manager) { double(:cert_manager).as_null_object }
  let(:server) { double(:server, cert_manager: cert_manager).as_null_object }

  before :each do
    subject.instance_variable_set :@server, server
  end

  describe "#post_init" do
    subject { Mumble::Connection.allocate }

    it "should start a TLSv1 session" do
      expect(subject).to receive(:start_tls){|arg| expect(arg).to include ssl_version: :TLSv1 }

      subject.post_init
    end
  end
end
