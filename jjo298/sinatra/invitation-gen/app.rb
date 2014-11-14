require 'sinatra'
require 'rubygems'
require 'data_mapper'
require 'fileutils'
require 'dm-core'
require 'dm-types/yaml'
require 'fileutils'

def validate_caller_id(call_id)
	first_digit = call_id.split('')[0];
	#check to see if we need to add a 1
	if (first_digit != '1' && call_id.length == 10)
		call_id = "1" + call_id
	end
	return call_id
end

def gen_call_file(number, context, extension)
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
	file.puts("WaitTime: 30\n")
	file.puts("Context: " + context + "\n")
	file.puts("Extension: " + extension + "\n")
	# # file.puts("Set: " + vars + "\n") unless vars == ""
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

DataMapper.auto_upgrade!

DataMapper.finalize

get '/' do
  erb :index
end

post '/sendinvite' do
	uid = rand(9999)

	new_invite = Invitation.create(:uid => uid, :username => params[:username], :usernumber => params[:usernumber], :name_audio => nil)

	for i in 1..5
		current_symbol = ("number" + "#{i}").to_sym
		new_number = Number.create(:phonenumber => params[current_symbol])
		new_invite.numbers << new_number
	end

	new_invite.save

	callfile_num = validate_caller_id(params[:usernumber])

	gen_call_file(callfile_num, 'jjo298', 's')

	"IMPORTANT -- Your pin is: #{uid}, number calling is #{callfile_num}"
	# #{params[:username]}, #{params[:usernumber]}, #{params[:number1]},
	# #{params[:number2]},#{params[:number3]},#{params[:number4]},
	# #{params[:number5]}"
	 
end