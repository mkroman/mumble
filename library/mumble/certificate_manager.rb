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
    end

    # Restore the certificates from disk.
    def restore
      load_public_certificate
      load_private_key
    end

    # Load the public certificate from a file.
    #
    # @return [OpenSSL::X509::Certificate] the certificate.
    def load_public_certificate
      cert_path = File.join certificates_path, 'public.crt'

      if File.exist? cert_path
        @public_certificate = OpenSSL::X509::Certificate.new File.read cert_path
      else
        @public_certificate = generate_public_certificate
      end

      @public_certificate
    end

    # Load the private key from a file.
    #
    # @return [OpenSSL::PKey::RSA] the key.
    def load_private_key
      key_path = File.join certificates_path, 'private.key'

      if File.exist? key_path
        @private_key = OpenSSL::PKey::RSA.new File.read key_path
      else
        @private_key = generate_private_key
      end
    end

    # @return [String] the directory path where the certificates are located.
    def certificates_path
      Dir.pwd
    end

    def generate_public_certificate
      OpenSSL::X509::Certificate.new
    end
  end
end

