require './Server.rb'

begin
  @server = Server.new(2201, 'localhost')
  @server.startServer
rescue Interrupt
  @server.terminateServer
  puts "\nexiting..."
rescue Exception => e
  @server.terminateServer
  puts "Error: " + e.to_s
end
