# general purpose traffic logging thing. Direct your client to localhost
# and direct the script (see bottom) to the actual server and have the conversation
# logged in the folder of your choice

require 'socket'

# will create a conversation in the form of 1-q, 2-r, 3-q files containing packets that went back and forth
class LoggingTrafficHandler
	
	def initialize( folder )
		@folder = folder
		@sequence_number = 0
	end

	def handle_client_message( clientMsg )
	  fileName = @folder + "//" + "#{@sequence_number}-q.txt"
	  File.open( fileName, 'w') {|f| f.write( clientMsg ) }
	  @sequence_number = @sequence_number + 1
	end

	def handle_server_response( serverResponse )
	  fileName = @folder + "//" + "#{@sequence_number}-r.txt"
	  File.open( fileName, 'w') {|f| f.write( serverResponse ) }
	  @sequence_number = @sequence_number + 1
	end

end


class TrafficHandler
	def handle_client_message( clientMsg )
		puts "in: #{clientMsg}"
	end

	def handle_server_response( serverResponse )
		puts "out: #{serverResponse}"
	end
end

class Snitch 

	def initialize( inaddress, inport, outaddress, outport, trafficHandler )
		@inaddress = inaddress
		@inport = inport
		@outaddress = outaddress
		@outport = outport
		@trafficHandler = trafficHandler
	end

	def start
		server = TCPServer.new( @inaddress, @inport )
		remoteServer = TCPSocket.new( @outaddress, @outport )
		puts "listening on #{@inport}"
		relayedClient = server.accept
		puts "client connected"		
		reader = Thread.new() {
		  begin 
  			loop do
  				msg = relayedClient.readpartial( 5000 )
  				remoteServer.write( msg )
  				@trafficHandler.handle_client_message( msg )
  			end
  		rescue
		    puts "client-reader-server-writer thread down"
		  end
		  
		}
		writer = Thread.new() {
		  begin
  			loop do
  			  begin 
  				  fromServer = remoteServer.readpartial( 60000 )
  				rescue
  				  puts "failed reading from remote server"
  				  raise
				  end
  				begin 
  				  relayedClient.write( fromServer )
  				rescue
  				  puts "failed relaying packet to client"
  				  raise
				  end
  				@trafficHandler.handle_server_response( fromServer )
  			end
  		rescue
  		  puts "server-reader-client-writer thread down"
		  end
		}

		reader.join
	end

end

localaddr = "localhost"
remoteaddr = "wherever.com"
s = Snitch.new( localaddr, 6487, remoteaddr, 6487, LoggingTrafficHandler.new("//Users//maksa//traffic") )

s.start()
