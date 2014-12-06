require 'digest'

module MetaInfo
  # client side
  IP = "127.0.0.1"
  PORT_SERVER = 50504
  PORT_CLIENTS = 50505
  
  HELLO_MSG = [1000].pack('q')
  DISTURBED_MSG = [9000].pack('q')
  DISCON_MSG = [3000].pack('q')
end