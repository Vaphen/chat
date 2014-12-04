require 'socket'
require 'digest'

class Server
  def initialize
    @ip = "127.0.0.1"
    @port = 4917
    @u1 = UDPSocket.new
    @u1.bind(@ip, @port)
  end

  def getControlSum
    md5 = Digest::MD5.new
    md5 << @message
    return md5
  end

  def getMessage
    #arrSize = getMessageSize
    i = 0
    hashSum, size = 0
    3.times do
      if i == 0
        hashSum = @u1.recvfrom(32)
        i += 1
      elsif i == 1
        size = @u1.recvfrom(4)
        i += 1
      elsif i == 2
        output = @ul.recvfrom(size)
        puts output
      end
      
      puts hashSum
    end
   
    #size = @ul.recvfrom(4)
   # size = size[0].unpack('l')
  #  message = @ul.recvfrom(size[0])[0]
   # puts checkSum + size
  end

end

if __FILE__ == $0
  server = Server.new
  server.getMessage
end
