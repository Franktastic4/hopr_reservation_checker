require 'rails_helper' # includes the spec_helper, must run rails generate rspec:install
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
end

describe ReservationsController, type: :controller do
  let(:subject) { described_class.new }
  let(:url) { "https://www.opentable.com/restref/api/availability" }
  let(:headers) do
    {
      "Authorization" => "Bearer " + "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJvdGNmcCI6IjQ0MTM2ZmEzNTViMzY3OGExMTQ2YWQxNmY3ZTg2NDllOTRmYjRmYzIxZmU3N2U4MzEwYzA2MGY2MWNhYWZmOGEiLCJpYXQiOjE2MjA2ODA2OTAsImV4cCI6MTYyMDY5MTQ5MH0.ZnhtxVAMiLtW4zJCMa3OCqeRQcmizgFgbKyhpF4uFrU",
      "Content-Type" => "application/json"
    }
  end
  let(:body_no_reservation) do
    {
      "rid": 1779,
      "dateTime": "2021-05-10T19:00",
      "partySize": 2
    }
  end
  let(:body_with_reservation) do
    {
      "rid": 1779,
      "dateTime": "2022-03-17T19:00",
      "partySize": 2
    }
  end

  context "#find_hopr_reservations" do
    it "with no reservations" do
      VCR.use_cassette("hopr_no_reservations") do
        HTTParty.post(url, headers: headers, body: body_no_reservation.to_json)
      end
    end

    it "with reservations" do
      VCR.use_cassette("hopr_with_reservations") do
        HTTParty.post(url, headers: headers, body: body_with_reservation.to_json)
      end
    end
  end

  context "#between_reservation_time" do
    let(:start_time) { "17:00" } # 5
    let(:end_time) { "19:00" } # 7

    it "finds reservation times" do
      VCR.use_cassette("hopr_with_reservations") do
        response = HTTParty.post(url, headers: headers, body: body_with_reservation.to_json)
        availabilities = response["availability"]
        dates = availabilities.keys.select { |k| subject.is_date?(k) }

        matching_days = dates.select do |date|
          availability = availabilities[date]
          subject.between_reservation_time?(availability, start_time, end_time)
        end

        binding.pry
        assert_equal 4, matching_days.count
      end
    end

    it "finds no reservation times" do
      VCR.use_cassette("hopr_no_reservations") do
        response = HTTParty.post(url, headers: headers, body: body_no_reservation.to_json)
        availabilities = response["availability"]
        dates = availabilities.keys.select { |k| subject.is_date?(k) }

        matching_days = dates.select do |date|
          availability = availabilities[date]
          subject.between_reservation_time?(availability, start_time, end_time)
        end

        assert_equal 0, matching_days.count
      end
    end
  end
end
