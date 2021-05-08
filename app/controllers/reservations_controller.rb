class ReservationsController < ApplicationController
  include ReservationsHelper # Bring in module methods as if it was a part of this class
  include HTTParty
  skip_before_action :verify_authenticity_token

  def find_hopr_reservations
    url = "https://www.opentable.com/restref/api/availability"

    permitted = params
      .permit!
      .with_defaults(seats: "2", days: "5")

    headers = build_headers(permitted)
    seats = permitted[:seats]
    days = permitted[:days].to_i

    request_bodies = build_request_bodies(days, seats)
    valid_days = []

    request_bodies.each do |request_body|
      response = HTTParty.post(url, headers: headers, body: request_body.to_json)
      availabilities = response["availability"].to_h

      availabilities.keys.each do |date|
        next unless (Date.parse(date) rescue nil)
        valid_days.append(date) if check_date_is_open(availabilities[date])
      end
      sleep(1.seconds)
    end

    render json: valid_days
  end
end
