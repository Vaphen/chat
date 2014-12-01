require 'socket'

class Server
  include Socket::Constants
   
  def initialize(port = 2203, ip = 'localhost')
    @port = port
    @ip = ip
  end

  def startServer
    puts @port.to_s + @ip.to_s
    @socket = Socket.new(AF_INET, SOCK_STREAM, 0)
    sockaddr = Socket.pack_sockaddr_in(@port, '0.0.0.0')
    @socket.bind(sockaddr)
    @socket.listen(5)
    client, client_addrinfo = @socket.accept
    begin
      while data = client.recvfrom(500)[0].chomp do
        
        print "John Anon: #{data} >>>> "
        if data.length > 499
          puts "Die empfangene Nachricht ist zu lang."
          puts "Bitten Sie Ihren Partner unter 500 Zeichen zu bleiben."
        end
      
      end
    end
  rescue Interrupt
    @socket.close
  end

  def terminateServer
    @socket.close
  end
end