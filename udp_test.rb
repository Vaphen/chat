require 'socket'
require 'digest'

class Udp_test
  def initialize(ip = "127.0.0.1", port = 4919)
    @ip = ip
    @port = port
    @message = ""
    @u1 = UDPSocket.new
   # @u1.bind(@ip, @port)
  end

  def <<(message)
    @message = message
  end

  def getControlSum
    md5 = Digest::MD5.new
    md5 << @message
    return md5
  end

  def getMessageSize
    arrSize = Array.new
    arrSize.push @message.length()
    return arrSize
  end

  def sendMessage
    arrSize = getMessageSize
    @u1.send(getControlSum.to_s, 0, @ip, @port)
    @u1.send arrSize.pack('l'), 0, @ip, @port
    @u1.send(@message, 0, @ip, @port)
   end
end

if __FILE__ == $0
  client = Udp_test.new("127.0.0.1",4917)
  client << "Hallo, ich bin ein Programm."
  client.sendMessage()
end