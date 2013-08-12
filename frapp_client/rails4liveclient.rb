require 'frappuccino'
require 'net/http'
require 'socket'

class Emiter
  def work(command)
    emit(command)
  end
end

class Rails4LiveClient
  def initialize(uri,emiter)
    @uri = URI(uri)
    @emiter = emiter
  end

  def poll
    socket = TCPSocket.open @uri.host, @uri.port
    socket.puts "GET / HTTP/1.1\r\n"
    socket.puts "\r\n"
    while command = socket.gets
      @emiter.work(command)
    end
    socket.close
  end
end

emiter = Emiter.new
stream = Frappuccino::Stream.new(emiter)
client = Rails4LiveClient.new('http://127.0.0.1:3000', emiter)

client.poll

stream.map do |event|
  puts event
end
