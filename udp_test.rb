require 'socket'
require 'digest'

require './metaInfo.rb'

class Client
  def initialize(ip = "127.0.0.1", port = 4919)
    @ipList = Array.new
    @nameList = Array.new
    @ip = ip
    @port = port
    @message = ""
    @u1 = UDPSocket.new
   # @u1.bind(@ip, @port)
  end

  def connect
    @u1.send(MetaInfo::HELLO_MSG_HASH.to_s, 0, @ip, @port)
    @u1.send(MetaInfo::HELLO_MSG, 0, @ip, @port)
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
    @u1.send arrSize.pack('q'), 0, @ip, @port
    @u1.send(@message, 0, @ip, @port)
   end
end

if __FILE__ == $0
  client = Client.new("127.0.0.1",4917)
  client.connect
  client << "Hallo, ich bin ein Programm."
  client.sendMessage()
end