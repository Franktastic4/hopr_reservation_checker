module ReservationsHelper

  def build_headers(permitted)
    {
      "Authorization" => "Bearer " + permitted[:bearer_token],
      "Content-Type" => "application/json"
    }
  end

  def check_date_is_open(date_response)
    date_response.keys.exclude?("allNoTimesReasons")
  end

  # 7 is between 5-9pm, airtable checks +-2 hrs
  def build_request_bodies(days, seats)
    date = Date.today
    (1..days).map do |i|
      future_date = (date + i.days).to_s + "T19:00" # set to 7pm

      {
        "rid": 1779,
        "dateTime": future_date,
        "partySize": seats
      }
    end
  end
end
