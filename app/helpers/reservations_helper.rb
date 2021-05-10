module ReservationsHelper
  def is_date?(date)
    begin
      Date.parse(date)
      return true
    rescue
      return false
      end
  end

  def build_headers(permitted)
    {
      "Authorization" => "Bearer " + permitted[:bearer_token],
      "Content-Type" => "application/json"
    }
  end

  def check_date_is_open(date_response)
    not date_response["timeSlots"].empty?
  end

  def between_reservation_time?(date_response, start_time, end_time)
    # If you can get time of day, you do to_i to get seconds since epoch
    start_time_seconds = Time.parse(start_time).to_i
    end_time_seconds = Time.parse(end_time).to_i

    date_response["timeSlots"].each do |timeslot|
      reservation_time = Time.parse(timeslot["time"]).to_i
      if start_time_seconds <= reservation_time and reservation_time >= end_time_seconds
        return true
      end
    end

    false
  end

  # 7 is between 5-9pm, airtable checks +-2 hrs
  def build_request_bodies(days, seats, start_date)
    (1..days).map do |i|
      future_date = (start_date + i.days).to_s + "T19:00" # set to 7pm

      {
        "rid": 1779,
        "dateTime": future_date,
        "partySize": seats
      }
    end
  end
end
