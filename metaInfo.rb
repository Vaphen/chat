require 'digest'
#sdf
module MetaInfo
  # client side
  HELLO_MSG = [1000].pack('q')
  HELLO_MSG_HASH = Digest::MD5.new.update '1000'[0..3]
end