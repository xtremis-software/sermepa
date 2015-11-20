#
# Contains utility methods to generate a compliant HMAC-SHA256 signature for Redsys
#
module SermepaWebTpv
  module SignatureGeneration
    def signature(encoded_params, operation_key)
      signature = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), operation_key, encoded_params)
      Base64.strict_encode64(signature)
    end

    def operation_key(merchant_order)
      cipher = OpenSSL::Cipher::Cipher.new('DES-EDE3-CBC')
      cipher.encrypt
      cipher.key = Base64.decode64(SermepaWebTpv.merchant_secret_key)
      data = merchant_order.to_s
      if (data.bytesize % 8) > 0
        data += "\0" * (8 - data.bytesize % 8)
      end
      cipher.update(data)
    end
  end
end
