require 'spec_helper'

describe SermepaWebTpv::Request do
  let(:transaction) { OpenStruct.new(amount: 100, transaction_number: 1111) }
  let(:request) { SermepaWebTpv::Request.new(transaction, 'Test product') }

  before(:each) do
    SermepaWebTpv.merchant_secret_key = 'lq7HjrUOBfKmC578ILgskD5srU870gJ8'
  end

  it 'contains the signature version' do
    expect(request.options).to include('DS_SIGNATUREVERSION' => 'HMAC_SHA256_V1')
  end

  it 'encodes the merchant params' do
    encoded_merchant_params = request.options['DS_MERCHANTPARAMETERS']
    merchant_params = JSON.parse(Base64.decode64(encoded_merchant_params))

    expect(merchant_params).to include('DS_MERCHANT_AMOUNT' => '10000')
    expect(merchant_params).to include('DS_MERCHANT_PRODUCTDESCRIPTION' => 'Test product')
  end

  it 'generates a proper HMAC-SHA256 signature' do
    expect(request.options['DS_SIGNATURE']).to eq('/vrc2PJDrsOTihUX6AnU0+YLTfMPMKUkhEzO/z4ohPc=')
  end

  it 'generates required fields for the web form' do
    expect(request.options.keys).to match_array(%w(DS_SIGNATUREVERSION DS_MERCHANTPARAMETERS DS_SIGNATURE))
  end
end
