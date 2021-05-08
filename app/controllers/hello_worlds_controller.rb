# App to check for next open reservations at
# multiple restaurants Using shitty apps like OpenTable


# class name should end in "s", ex: worlds
class HelloWorldsController < ApplicationController
  # Debugging should start here so you know what inputs to expect
  # Also so you can actually test it in QA

  def hello
    passed_id = params[:id]

    if passed_id
      render html: "Hello ID: #{passed_id}"
    else
      render html: "Hello World!"
    end
  end
end
