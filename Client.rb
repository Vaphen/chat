require 'socket'

class Client
  include Socket::Constants
  
  def initialize(port = 2203, ip = 'localhost')
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
      @socket.puts peter.pack("q")
      @socket.puts userInput
    rescue Exception=>e
      puts "Error: " + e.to_s
      puts @port.to_s + @ip.to_s
      exit
    end
  
    getInput
    
  end

  def terminateClient
    @socket.close
  end
end
