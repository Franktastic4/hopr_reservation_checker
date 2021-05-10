module ReservationsHelper

  def build_headers(permitted)
    {
      "Authorization" => "Bearer " + permitted[:bearer_token],
      "Content-Type" => "application/json"
    }
  end

  def check_date_is_open(date_response)
    not date_response["timeSlots"].empty?
  end

  # def is_before_time(date_response, time)
  #   date_response["timeSlots"].each do |timeslot|
  #     if Time.parse(timeslot["time"]) > time
  #       return true
  #     end
  #   end
  #
  #   false
  # end

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
