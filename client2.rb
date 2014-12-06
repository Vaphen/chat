require 'socket'
require 'zlib'
require './metaInfo.rb'

class Client
  include MetaInfo

  # TODO: For debugging issues
  OTHER_CLIENT_PORT = 50506
  def initialize(ip = IP, port = PORT_SERVER)
    @ipList = Array.new
    @nameList = Array.new
    @ip = ip
    @port = port
    @u1 = UDPSocket.new

    # TODO: For debugging issues
    @port = 50507

    @u1.bind(@ip, @port)

    # TODO: For debugging issues
    @port =  50500
  end

  def connect
    @u1.send(MetaInfo::HELLO_MSG, 0, "127.0.0.1", 50504)
    tNewIpLists = Thread.new {
      while true
        ipListChecksum = @u1.recvfrom(4)[0]
        ipListSize = @u1.recvfrom(8)[0].unpack('q')[0]
        ipList = @u1.recvfrom(ipListSize)[0]
        if getControlSum(ipList) == ipListChecksum
          @ipList = Marshal.load(ipList)
          puts @ipList
        else
          # TODO: Send disturbed_MSG back
        end
      end
    }
    tNewIpLists.join
  end

  def getControlSum(text)
    return [Zlib::crc32(text)].pack('L')
  end

  def getMessageSize(message)
    arrSize = Array.new
    arrSize.push message.length()
    return arrSize
  end

  def send_message(message)
    arrSize = getMessageSize(message)
    @u1.send(getControlSum(message), 0, @ip, OTHER_CLIENT_PORT)
    @u1.send arrSize.pack('q'), 0, @ip, OTHER_CLIENT_PORT
    @u1.send(message, 0, @ip, OTHER_CLIENT_PORT)
  end

  def receive_message
    loop {
      msgCheckSum = @u1.recvfrom(4)[0]
      msgLength = @u1.recvfrom(8)[0].unpack('q')[0]
      message = @u1.recvfrom(msgLength)[0]
      if msgCheckSum == getControlSum(message)
        puts message
      end
    }
  end

  def disconnect
    @u1.send(MetaInfo::DISCON_MSG, 0, @ip, @port)
  end

  private :getControlSum, :getMessageSize
end

if __FILE__ == $0
  client = Client.new("127.0.0.1", 50507)
  client.connect
  client.send_message()
  client.disconnect
end
