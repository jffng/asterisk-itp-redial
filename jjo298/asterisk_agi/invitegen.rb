#!/usr/bin/ruby

require 'ruby-agi'
require 'data_mapper'   #for database integration
require 'fileutils'

agi = AGI.new
ask_for_pin = "vm-extension"
no_pin_found = "vm-extension"
record_your_message = "vm-extension"

invites_location = "/home/jjo298/public_html/invitations/"

def validate_caller_id(call_id)
	first_digit = call_id.split('')[0];
	#check to see if we need to add a 1
	if (first_digit != '1' && call_id.length == 10)
		call_id = "1" + call_id
	end
	return call_id
end

def gen_call_file(number, context, extension, callerid)
	time = (Time.now.to_f * 1000).to_i 	#current timestamp
	temp_dir = "/tmp/"
	callfile = "call_" + time.to_s + ".call"
	startcallfile = temp_dir + callfile
	end_dir = "/var/spool/asterisk/outgoing/"
	endcallfile = end_dir + callfile
	#write file to disk
	file = File.open(startcallfile,"w")
	file.puts("Channel: SIP/flowroute/" + number + "\n")
	file.puts("MaxRetries: 1\n")
	file.puts("RetryTime: 60\n")
	file.puts("Callerid: " + callerid + "\n")
	file.puts("WaitTime: 30\n")
	file.puts("Context: " + context + "\n")
	file.puts("Extension: " + extension + "\n")
	# file.puts("Set: " + vars + "\n") unless vars == ""
	file.close
	# #change file permission
	File.chmod(0777, startcallfile)
	FileUtils.chown(ENV['USER'],'asterisk',startcallfile)
	# #hour-minute-second-month-day-year (example: 02-10-00-09-27-2007)
	# timesplit = touchtime.split('-')
	# ctime = Time.local(timesplit[5],timesplit[3],timesplit[4],timesplit[0],timesplit[1],timesplit[2])
	# File.utime(ctime,ctime,startcallfile) #change file time to future date

	# #move file to /var/spool/asterisk/outgoing
	FileUtils.mv(startcallfile,endcallfile)
end

DataMapper.setup(:default, {
	:adapter => 'mysql',
	:host => 'localhost',
	:username => 'jjo298',
	:password => 'oclizpzg',
	:database => 'jjo298'
	})

class Invitation
	include DataMapper::Resource
	
	property :id, 				Serial
	property :uid, 				Integer, :required => true
	property :username,			String, :required => true
	property :usernumber, 		String, :required => true
	property :name_audio,		String

	has n,	 :numbers
end

class Number
	include DataMapper::Resource
	
	property :id,				Serial
	property :phonenumber,		String, :required => true

	belongs_to :invitation
end

DataMapper.finalize

# callerID = validate_caller_id(agi.callerid)
# agi.noop("validated id " + callerID)

# caller = Invitation.last(:usernumber => callerID)

user_pin = agi.wait_for_digits(ask_for_pin, nil, 5)

invite = Invitation.last(:uid => user_pin.digits) 

if invite
	agi.noop("Pin: " + user_pin.digits)
	agi.stream_file(record_your_message)
	sleep(1)

	record_file = invites_location + user_pin.digits

	agi.record_file(record_file, "WAV", "0123456789#*", 10000, true)

	invite.update(:name_audio => record_file)

	invite.save

	nums = invite.numbers
	nums.each_with_index do |num, i|
		num_to_call = validate_caller_id(num.phonenumber)
		if(num_to_call.length == 11)
			gen_call_file( num_to_call, 'jjo298_callfind', 's', user_pin.digits)
			agi.noop(num_to_call)
		end
	end
else
	agi.stream_file(no_pin_found)
end


