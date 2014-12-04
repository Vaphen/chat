require './Client.rb'

begin
client = Client.new(2201, 'localhost')
client.startClient
client.getInput
rescue Interrupt
  client.terminateClient
  puts "\nexiting..."
rescue Exception => e
  client.terminateClient
  puts e
end