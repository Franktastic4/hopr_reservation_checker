class ReservationsController < ApplicationController
  include ReservationsHelper # Bring in module methods as if it was a part of this class
  include HTTParty
  skip_before_action :verify_authenticity_token

  def find_hopr_reservations
    url = "https://www.opentable.com/restref/api/availability"

    permitted = params
      .permit!
      .with_defaults(seats: "4", days: "5", start_date: Date.today.to_s)

    headers = build_headers(permitted)
    seats = permitted[:seats]
    days = permitted[:days].to_i
    start_date = Date.parse(permitted[:start_date])

    request_bodies = build_request_bodies(days, seats, start_date)
    valid_days = Set.new

    request_bodies.each do |request_body|
      response = HTTParty.post(url, headers: headers, body: request_body.to_json)
      availabilities = response["availability"].to_h
      availabilities.keys.each do |date|
        next unless (Date.parse(date) rescue nil)
        if check_date_is_open(availabilities[date])
          valid_days.add(date)
        end
      end
      sleep(1.seconds)
    end

    render json: valid_days.to_a.sort
  end
end
