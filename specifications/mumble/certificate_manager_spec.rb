require_relative '../spec_helper'

fixtures_path = File.dirname(__FILE__) + '/../fixtures'

describe Mumble::CertificateManager do
  KEY = File.read File.join fixtures_path, 'private.key'
  CERT = File.read File.join fixtures_path, 'public.crt'

  describe 'default attributes' do
    it { should respond_to :public_certificate }

    it { should respond_to :private_key }
  end

  its(:certificates_path) { is_expected.to be_kind_of String }

  describe '#certificates_path' do
    it 'should return the current working directory' do
      expect(subject.certificates_path).to eq Dir.pwd
    end
  end

  describe '#restore' do
    before do
      allow(subject).to receive :load_private_key
      allow(subject).to receive :load_public_certificate
    end

    it 'should load a public certificate' do
      expect(subject).to receive :load_public_certificate

      subject.restore
    end

    it 'should load a private key' do
      expect(subject).to receive :load_private_key

      subject.restore
    end
  end

  describe '#load_public_certificate' do
    context 'when the certificate exists' do
      before do
        allow(File).to receive(:exist?).and_return true
        allow(File).to receive(:read).and_return CERT
      end

      it 'should read the certificate' do
        expect(File).to receive :read

        subject.load_public_certificate
      end

      it 'should return a x509 certificate' do
        expect(subject.load_public_certificate).to be_kind_of OpenSSL::X509::Certificate
      end
    end

    context "when the certificate doesn't exist" do
      it 'should generate a certificate' do
        expect(subject).to receive :generate_public_certificate

        subject.load_public_certificate
      end

      it 'should save the certificate'
    end

    it 'should return a certificate' do
      expect(subject.load_public_certificate).to be_kind_of OpenSSL::X509::Certificate
    end
  end

  describe '#load_private_key' do
    context 'when the private key exists' do
      before do
        allow(File).to receive(:exist?).and_return true
        allow(File).to receive(:read).and_return KEY
      end

      it 'should read the key' do
        expect(File).to receive(:read).with kind_of String

        subject.load_private_key
      end

      it 'should return a rsa key' do
        expect(subject.load_private_key).to be_kind_of OpenSSL::PKey::RSA
      end
    end

    context 'when the private key does not exist' do
      before do
        allow(File).to receive(:exist?).and_return false
      end

      it 'should generate a new key' do
        expect(subject).to receive :generate_private_key

        subject.load_private_key
      end

      it 'should return the generated key' do
        key = double :key
        allow(subject).to receive(:generate_private_key).and_return key

        expect(subject.load_private_key).to eq key
      end
    end
  end

  describe '#generate_private_key' do
    let(:file_stub) { double(:file).as_null_object } 
    let(:private_key) { double(:private_key).as_null_object }
    before(:each) { allow(File).to receive(:open).and_yield file_stub }

    it 'should generate a new rsa key' do
      expect(OpenSSL::PKey::RSA).to receive(:generate).and_return private_key

      subject.generate_private_key
    end

    it 'should save the key' do
      expect(File).to receive :open
      expect(file_stub).to receive :write

      subject.generate_private_key
    end

    it 'should save as pem' do
      expect_any_instance_of(OpenSSL::PKey::RSA).to receive(:to_pem)

      subject.generate_private_key
    end
  end
end
