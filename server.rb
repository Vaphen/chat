require 'socket'
require 'digest'
require './metaInfo.rb'
#sdf
class Server
  def initialize
    @ipList = Array.new
    @ip = "127.0.0.1"
    @port = 4917
    @u1 = UDPSocket.new
    @u1.bind(@ip, @port)
  end

  def wait_for_clients
    message = @u1.recvfrom(32)
    if MetaInfo::HELLO_MSG_HASH == message[0]
      @ipList << message[2]
    end
    puts message
    puts @ipList
  end

  def getControlSum
    md5 = Digest::MD5.new
    md5 << @message
    return md5
  end

  def get_message

    i = 0

    hashSum = @u1.recvfrom(32)

    size = @u1.recvfrom(8)

    size = size[0].unpack('q')[0]
    #message = @u1.recvfrom(size)
    #puts message[0]

    #size = @ul.recvfrom(4)
    # size = size[0].unpack('l')
    #  message = @ul.recvfrom(size[0])[0]
    # puts checkSum + size
  end

end

if __FILE__ == $0
  server = Server.new
  server.wait_for_clients
  server.get_message
end
