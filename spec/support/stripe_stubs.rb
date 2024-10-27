# frozen_string_literal: true

RSpec.configure do |config|
  config.before do
    stub_request(:post, "https://api.stripe.com/v1/products")
      .to_return(
        status:  200,
        body:    { id: "prod_test_id" }.to_json,
        headers: { "Content-Type" => "application/json" }
      )

    stub_request(:post, "https://api.stripe.com/v1/prices")
      .to_return(
        status:  200,
        body:    { id: "price_test_id" }.to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end
end
