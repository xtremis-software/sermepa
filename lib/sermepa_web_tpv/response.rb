require_relative 'signature_generation.rb'
require 'active_support/core_ext/hash/indifferent_access'

#
# Parses a notification response from Redsys and determines whether it's legit or not
#
module SermepaWebTpv
  class Response < Struct.new(:params)
    include SermepaWebTpv::SignatureGeneration

    def valid?
      response_signature = Base64.strict_encode64(Base64.urlsafe_decode64(params[:Ds_Signature]))
      calculated_signature = signature(params[:Ds_MerchantParameters], operation_key(merchant_params[:Ds_Order]))
      response_signature == calculated_signature
    end

    def success?
      merchant_params[:Ds_Response].to_i == 0
    end

    def merchant_params
      @merchant_params ||= JSON.parse(Base64.decode64(params[:Ds_MerchantParameters])).with_indifferent_access
    end
  end
end