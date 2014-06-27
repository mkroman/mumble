require_relative '../spec_helper'

describe Mumble::Connection do
  describe "#post_init" do
    it "should start a tls session" do
      m = Mumble::Connection.allocate
      expect(m).to receive(:start_tls)

      m.post_init
    end
  end
end
