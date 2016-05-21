# A Simple Carnivore Client -- print packets in Processing console
#
# Note: requires Carnivore Library for Processing (http://r-s-g.org/carnivore)
#
# + Windows:  first install winpcap (http://winpcap.org)
# + Mac:      first open a Terminal and execute this commmand: sudo chmod 777 /dev/bpf*
#             you need to do this each time you reboot Mac
# + Linux:    run with difficulty (run with sudo or some hack) also install libpcap

load_library :carnivore
include_package 'org.rsg.carnivore'
java_import 'org.rsg.lib.Log'
require_relative 'carnivore_listener'

include Java::Monkstone::CarnivoreListener

attr_reader :c

def settings
  size(600, 400)
end

def setup
  sketch_title 'Carnivore Example'
  background(255)  
  @c = CarnivoreP5.new(self)
  Log.setDebug(true) # comment out for quiet mode
  # c.setVolumeLimit(4) #limit the output volume (optional)
  # c.setShouldSkipUDP(true) #tcp packets only (optional)
end

def draw
end

# Called each time a new packet arrives
def packetEvent(p)
  puts(format('(%s packet) %s > %s', p.strTransportProtocol, p.senderSocket, p.receiverSocket))
  # puts(format('Payload: %s', p.ascii))
  # puts("---------------------------\n")
end
