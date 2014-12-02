#!/usr/bin/env ruby

require 'data_mapper'
require 'ruby-agi'
require 'socket'
require 'uri'
require_relative 'model.rb'

agi = AGI.new
@uniqueid = agi.uniqueid
@hangup_sent
host = 'localhost'
port = 12001
@sock = TCPSocket.open(host, port)

#method to send hangup event
def send_hangup(val)
	if !@hangup_sent
		@hangup_sent = true
		@sock.puts "id:#{@uniqueid},event:hangup,value:#{val}"
	end
end

#make sure hangup is sent on exit
Signal.trap(0, proc { send_hangup(1) })

#send new caller message
callerid = agi.calleridnumber
if !callerid
    callerid = agi.callerid
end
#get rid of plus, if it's there
if callerid[0] == '+'[0]
    callerid.slice!(0)
end

argsValue = ""
#don't allow reserved characters through.
reserved_chars=/[{,|:}]/
#add args to value, if there's any
ARGV.each do |arg|
    argsValue << "|" + URI.escape(arg.gsub(reserved_chars,""))
end
@sock.puts "id:#{@uniqueid},event:new_call,value:#{callerid}|#{agi.dnid}#{argsValue}"

agi.stream_file("vm-extension")
sleep(1)

# start agi keypress loop

looping = true
while looping
	Emojiphrase.first(:has_recording=>false) ? emojiphrase = Emojiphrase.first(:has_recording=>false) : emojiphrase = Emojiphrase.first(:has_recording=>true)

	@sock.puts "id:#{@uniqueid},event:emojiphrase,emoji:#{emojiphrase.emoji},phrase:#{emojiphrase.phrase}"

	agi.stream_file("vm-extension") # "press 1 to begin a recording, and any key to end"

	result = agi.wait_for_digit(-1) # wait forever

	if result.digit
		@sock.puts "id:#{@uniqueid},event:keypress,value:#{result.digit}"	    	

		if result.digit == '1'
			relative_path = emojiphrase.emoji.tr("\ ", '').tr('.','').tr('\'','').tr('?','') + emojiphrase.phrase.tr("\ ", '').tr('.','').tr('\'','').tr('?','') + "#{@uniqueid}".tr('.','')
			# @sock.puts "id:#{@uniqueid},event:keypress,value:#{relative_path}"	    	

			record_file = "/root/emotiphone/recordings/" + relative_path
			agi.record_file(record_file, "WAV", "0123456789#*", 10000, true)

			rec = Recording.first_or_create( { :id=>1, :file_path=>record_file }, { :file_path=>record_file })

			emojiphrase.recordings << rec
			emojiphrase.has_recording = true
			emojiphrase.save
		end
	else #hangup broke the pending AGI request
		looping = false 
	end
end
send_hangup(0)

