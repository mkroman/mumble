# encoding: utf-8

module Mumble
  class CertificateManager
    # @return [String] the public X.509 certificate.
    attr_accessor :public_certificate

    # @return [String] the private RSA key.
    attr_accessor :private_key

    def initialize
      @private_key = nil
      @public_certificate = nil

      restore
    end

    # Restore the certificates from disk.
    def restore
      load_private_key
      load_public_certificate
    end

    # Load the public certificate from a file, or generate a new one.
    #
    # @return [OpenSSL::X509::Certificate] the certificate.
    def load_public_certificate
      cert_path = public_certificate_path

      if File.exist? cert_path
        @public_certificate = OpenSSL::X509::Certificate.new File.read cert_path
      else
        @public_certificate = generate_public_certificate
      end

      @public_certificate
    end

    # Load the private key from a file, or generate a new one.
    #
    # @return [OpenSSL::PKey::RSA] the key.
    def load_private_key
      if File.exist? private_key_path
        @private_key = OpenSSL::PKey::RSA.new File.read private_key_path
      else
        @private_key = generate_private_key
      end
    end

    # @return [String] the directory path where the certificates are located.
    def certificates_path
      Dir.pwd
    end

    # @return [String] the path to the public certificate.
    def public_certificate_path
      File.join certificates_path, 'public.crt'
    end

    # @return [String] the path to the private key.
    def private_key_path
      File.join certificates_path, 'private.key'
    end

    # Generate a new RSA key with 2048 bits and save it to disk.
    #
    # @return [OpenSSL::PKey::RSA] the generated key.
    def generate_private_key
      private_key = OpenSSL::PKey::RSA.generate 2048

      File.open private_key_path, 'w' do |file|
        file.write private_key.to_pem
      end

      private_key
    end

    def generate_public_certificate
      cert = OpenSSL::X509::Certificate.new
      cert.version = 2
      cert.serial = rand(65535) + 1
      cert.subject = cert.issuer = OpenSSL::X509::Name.parse "/CN=hello/"
      cert.public_key = @private_key.public_key
      cert.not_before = Time.now
      cert.not_after = Time.now + 1 * 365 * 24 * 60 * 60

      ef = OpenSSL::X509::ExtensionFactory.new
      ef.subject_certificate = cert
      ef.issuer_certificate = cert
      cert.add_extension ef.create_extension 'keyUsage', 'keyCertSign, cRLSign', true
      cert.add_extension ef.create_extension 'subjectKeyIdentifier', 'hash', false
      cert.sign @private_key, OpenSSL::Digest::SHA256.new

      File.open public_certificate_path, 'w' do |file|
        file.write cert.to_pem
      end

      @public_certificate = cert
    end
  end
end

