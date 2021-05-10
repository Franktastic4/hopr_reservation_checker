require 'rails_helper' # includes the spec_helper, must run rails generate rspec:install
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
end

describe ReservationsController, type: :controller do
  context "find_hopr_reservations" do
    let(:url) { "https://www.opentable.com/restref/api/availability" }
    let(:headers) do
      {
        "Authorization" => "Bearer " + "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJvdGNmcCI6IjQ0MTM2ZmEzNTViMzY3OGExMTQ2YWQxNmY3ZTg2NDllOTRmYjRmYzIxZmU3N2U4MzEwYzA2MGY2MWNhYWZmOGEiLCJpYXQiOjE2MjA2ODA2OTAsImV4cCI6MTYyMDY5MTQ5MH0.ZnhtxVAMiLtW4zJCMa3OCqeRQcmizgFgbKyhpF4uFrU",
        "Content-Type" => "application/json"
      }
    end
    let(:body) do
      {
        "rid": 1779,
        "dateTime": Date.today.to_s + "T19:00",
        "partySize": 2
      }
    end

    it "posts to hopr" do
      VCR.use_cassette("hopr") do
        HTTParty.post(url, headers: headers, body: body.to_json)
      end
    end
  end
end
