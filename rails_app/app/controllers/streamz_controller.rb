class StreamzController < ApplicationController
  include ActionController::Live
  def send_command
    response.headers['Content-Type'] = 'text/event-stream'
    5.times {
      response.stream.write "command!\n"
    }
    response.stream.close
  end
end
