require_relative 'signature_generation.rb'
require 'uri'

#
# Takes care of building a payment request as well as generating a valid signature
#
module SermepaWebTpv
  class Request < Struct.new(:transaction, :description)
    include SermepaWebTpv::SignatureGeneration
    include SermepaWebTpv::Persistence::ActiveRecord

    def bank_url
      SermepaWebTpv.bank_url
    end

    def options
      {
          ds_signatureversion: signature_version,
          ds_signature: signature(merchant_params, operation_key(transaction_number)),
          ds_merchantparameters: merchant_params
      }.transform_keys { |key| key.to_s.upcase }
    end

    def signature_version
      'HMAC_SHA256_V1'
    end

    def merchant_params
      form_fields = required_merchant_params.merge(optional_merchant_params)
      form_fields.transform_keys! { |key| key.to_s.upcase }

      Base64.strict_encode64(form_fields.to_json)
    end

    def transact(&block)
      generate_transaction_number!
      yield(transaction)
      self
    end

    private

    def required_merchant_params
      {
          ds_merchant_amount: amount,
          ds_merchant_currency: SermepaWebTpv.currency,
          ds_merchant_order: transaction_number.to_s,
          ds_merchant_productdescription: description,
          ds_merchant_merchantcode: SermepaWebTpv.merchant_code,
          ds_merchant_terminal: SermepaWebTpv.terminal,
          ds_merchant_transactionType: SermepaWebTpv.transaction_type,
          ds_merchant_consumerlanguage: SermepaWebTpv.language,
          ds_merchant_merchantuRL: url_for(:callback_response_path)
      }
    end

    def optional_merchant_params
      {
          ds_merchant_titular: SermepaWebTpv.merchant_name,
          ds_merchant_urlko: url_for(:redirect_failure_path),
          ds_merchant_urlok: url_for(:redirect_success_path),
          ds_merchant_paymethods: SermepaWebTpv.pay_methods
      }.delete_if { |key, value| value.blank? }
    end

    def transaction_number_attribute
      SermepaWebTpv.transaction_model_transaction_number_attribute
    end

    def transaction_model_amount_attribute
      SermepaWebTpv.transaction_model_amount_attribute
    end

    def amount
      (transaction_amount * 100).to_i.to_s
    end


    # Available options
    # redirect_success_path
    # redirect_failure_path
    # callback_response_path
    def url_for(option)
      host = SermepaWebTpv.response_host
      path = SermepaWebTpv.send(option)

      if host.present? && path.present?
        URI.join(host, path).to_s
      end
    end
  end
end