require 'spec_helper'

describe SermepaWebTpv::Response do
  ### Merchant params:
  # {
  #     "Ds_Date": "12/11/2015",
  #     "Ds_Hour": "17:05",
  #     "Ds_Amount": "145",
  #     "Ds_Currency": "978",
  #     "Ds_Order": "1442772645",
  #     "Ds_MerchantCode": "999008881",
  #     "Ds_Terminal": "871",
  #     "Ds_Response": "0",
  #     "Ds_MerchantData": "test merchant",
  #     "Ds_SecurePayment": "1",
  #     "Ds_TransactionType": "0"
  # }
  let(:response) { SermepaWebTpv::Response.new(Ds_MerchantParameters: 'ewogICAgIkRzX0RhdGUiOiAiMTIvMTEvMjAxNSIsCiAgICAiRHNfSG91ciI6ICIxNzowNSIsCiAgICAiRHNfQW1vdW50IjogIjE0NSIsCiAgICAiRHNfQ3VycmVuY3kiOiAiOTc4IiwKICAgICJEc19PcmRlciI6ICIxNDQyNzcyNjQ1IiwKICAgICJEc19NZXJjaGFudENvZGUiOiAiOTk5MDA4ODgxIiwKICAgICJEc19UZXJtaW5hbCI6ICI4NzEiLAogICAgIkRzX1Jlc3BvbnNlIjogIjAiLAogICAgIkRzX01lcmNoYW50RGF0YSI6ICJ0ZXN0IG1lcmNoYW50IiwKICAgICJEc19TZWN1cmVQYXltZW50IjogIjEiLAogICAgIkRzX1RyYW5zYWN0aW9uVHlwZSI6ICIwIgp9',
                                               Ds_Signature: 'aFPZAJP1ZwJOncUEiCOW1QqwjTZX41wmUvFO010Fvw4=') }
  #
  it 'calculates the signature and knows when the external request is legit' do
    expect(response.valid?).to eq(true)
  end

  it 'detects a successful response' do
    expect(response.success?).to eq(true)
  end

  it 'decodes the merchant parameters' do
    expect(response.merchant_params[:Ds_Amount]).to eq('145')
    expect(response.merchant_params[:Ds_MerchantCode]).to eq('999008881')
  end
end
