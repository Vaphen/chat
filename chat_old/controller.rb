#!/usr/bin/ruby

require './Client.rb'
require './Server.rb'

class Controller
  def initialize

    case ARGV.length
    when 0
      @ip = 'localhost'
      @port = 2005
    when 1
      @ip = ARGV[0]
      @port = 2005
    when 2
      @ip = ARGV[0]
      @port = ARGV[1]
    end

    puts "Starte Server..."
    puts "Starte Client..."

    begin

      server = Server.new(@port, @ip)
      client = Client.new(@port,@ip)
      
      client.startClient
      
      t1 = Thread.new {
        server.startServer
      }
      t2 = Thread.new {
        client.getInput
      }
      t1.join
      t2.join
      
      
     
     

      

      

    rescue Interrupt
      #server.terminateServer
    #  client.terminateClient
    rescue Exception => e
    #  server.terminateServer
    #  client.terminateClient
      puts "Error: " + e.to_s
    end

  end
end

root = Controller.new