require 'socket'
require 'zlib'
require './metaInfo.rb'

class Server
  def initialize
    @ipList = Array.new
    @ip = "127.0.0.1"
    @port = 50504
    @u1 = UDPSocket.new
    @u1.bind(@ip, @port)
  end

  def wait_for_clients
    loop {
      message = @u1.recvfrom(8)
      newIP = message[1][2]

      if MetaInfo::HELLO_MSG == message[0]
       # puts "Connect:\t#{message[1][2]}"

        # TODO: uncomment after debugging
      #  if(!@ipList.include? newIP)
          @ipList << newIP
          serializedIpList = Marshal.dump(@ipList)
          ipListSize = [serializedIpList.size]
          @ipList.each do |singleIp|
            puts singleIp
            @u1.send getControlSum(serializedIpList), 0, singleIp, 50506
            @u1.send ipListSize.pack('q'), 0, singleIp, 50506
            @u1.send serializedIpList, 0, singleIp, 50506
          end
    #    end

      elsif MetaInfo::DISCON_MSG == message[0]
        @ipList.delete newIP
     #   puts "Disconnect:\t#{newIP}"
      else
        puts "Ein Fehler ist beim verbinden aufgetreten."
      end
    }
  end

  def getControlSum(text)
    return [Zlib::crc32(text)].pack('L')
  end

  def get_message
    puts "in threrad"
    loop {
      hashSum = @u1.recvfrom(32)
      size = @u1.recvfrom(8)
      size = size[0].unpack('q')[0]
      message = @u1.recvfrom(size)
      # if(hashSum == getControlSum(message[0]))
      puts message[1][3].to_s + ": " + message[0]
      #   end
    }
  end

  def close
    @u1.close
  end
end

if __FILE__ == $0
  server = Server.new
  begin
    server.wait_for_clients
  rescue Interrupt
    server.close
    puts "\nP2P-Server stopped"
    # rescue Exception => e
    #  server.close
    # for debugging issues only
    #  puts e
    #   puts "\nAn unknown error occured."
  end
  #  server.get_message
end
