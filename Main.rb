require './udp_test.rb'

class Main
end

udp = Udp_test.new("127.0.0.1", 4917)
udp << "Hello, how are you?"
message = gets.chomp
udp.sendMessage