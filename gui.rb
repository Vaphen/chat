#!/usr/bin/env ruby

require 'gtk2'
require './client.rb'

class GUI
  def initialize

    # layout elements
    @layoutBox = Gtk::VBox.new(false, 5)
    @submitBox = Gtk::HBox.new(false, 5)

    # gui elements
    @chatArea = Gtk::TextView.new
    @inputArea = Gtk::TextView.new
    @submit = Gtk::Button.new("Nachricht senden")

    # size of elements
    @chatArea.set_size_request(500, 500)
    @inputArea.set_size_request(350, 30)
    @submit.set_size_request(150, 30)

    # chatArea settings
    @chatArea.set_editable false
    @chatArea.cursor_visible = false
    @chatArea.buffer.text = "Herzlich Willkommen zur Test-Version des P2P-Clients\n"
    @chatArea.buffer.text += "+----------------------\n"
    @chatArea.modify_base(Gtk::STATE_NORMAL,Gdk::Color.new(10000,10000,10000))
    @chatArea.modify_text(Gtk::STATE_NORMAL,Gdk::Color.new(65500, 65500, 65500))

    # inputArea settings
    @inputArea.modify_base(Gtk::STATE_NORMAL,Gdk::Color.new(20000,20000,20000))
    @inputArea.modify_text(Gtk::STATE_NORMAL,Gdk::Color.new(50000, 50000, 50000))
    @inputArea.add_events(Gdk::Event::KEY_PRESS)
    @inputArea.set_left_margin 4
    @inputArea.buffer.place_cursor(@inputArea.buffer.start_iter)

    # layout settings
    @submitBox.add(@inputArea)
    @submitBox.add(@submit)
    @layoutBox.add(@chatArea)
    @layoutBox.add(@submitBox)

    # main window
    @window = Gtk::Window.new("P2P-Chat-Client")
    @window.add(@layoutBox)
    @window.border_width = 10
    @window.set_resizable false
    @window.show_all

    # Client instance for functionality
    @client = Client.new
    @client.connect

    #signals
    @window.signal_connect("destroy") {
      @client.disconnect
      Gtk.main_quit
    }

    @submit.signal_connect("clicked") {
      send_text
    }

    @inputArea.signal_connect("key-press-event") do |w, e|
      if e.keyval == 65293
        send_text
      end
    end

  end

  def start_gui
    begin
      t1 = Thread.new {
        while message = @client.receive_message
          @chatArea.buffer.text += message += "\n"
        end
      }
      Gtk.main
    rescue Interrupt
      @client.disconnect
      puts "\nProgramm beenden..."
    rescue Exception=>e
      @client.disconnect
      puts "\nEin unbekannter Fehler ist aufgetreten."
    end
  end

  def send_text
    @client.send_message(@inputArea.buffer.text)
    @chatArea.buffer.text += "Ich: " + @inputArea.buffer.text + "\n"
    @inputArea.buffer.text = "";
  end

end

root = GUI.new
root.start_gui

