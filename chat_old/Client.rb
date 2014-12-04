require 'socket'

class Client
  include Socket::Constants
  
  def initialize(port = 2204, ip = 'localhost')
    @ip = ip
    @port = port
  end

  def startClient
    begin
      puts @ip.to_s + @port.to_s
      @socket = Socket.new( AF_INET, SOCK_STREAM, 0 )
      sockaddr = Socket.pack_sockaddr_in(@port, @ip)
      @socket.connect(sockaddr)
    rescue Exception=>e
      puts "Error: " + e.to_s
      exit
    end
  end

  def getInput
   
    print " >>>> "
    userInput = gets.chomp

    if userInput == "exit"
      @socket.close
      print "\n"
      exit
    end

    begin
      peter = Array.new
      peter.push(userInput.length)
      @socket.puts userInput
      @socket.gets.chomp
    rescue Exception=>e
      puts "Error: " + e.to_s
      exit
    end
  
    getInput
    
  end

  def terminateClient
    @socket.close
  end
end

if __FILE__ == $0
  client = Client.new()
  client.startClient()
  client.getInput()  
end