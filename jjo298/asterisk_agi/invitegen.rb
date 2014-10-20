#!/usr/bin/ruby

require 'ruby-agi'
require 'data_mapper'   #for database integration

agi = AGI.new
ask_for_pin = "vm-extension"

def validate_caller_id(call_id)
	callerid = /\<.+>/.match(call_id)[0]
	callerid[0]=''
	callerid[-1]=''
	
	first_digit = callerid.split('')[0]
	#check to see if we need to add a 1
	
	# puts 'first digit: ' + first_digit

	if (first_digit == '+')
		callerid[0] = ''
		first_digit = callerid.split('')[0]
	end

	if (first_digit != '1' && callerid.length == 10)
		callerid = "1" + callerid
	end

	# puts 'callerid: ' + callerid
	return callerid
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

	has n,	 :numbers
end

class Number
	include DataMapper::Resource
	
	property :id,				Serial
	property :phonenumber,		String, :required => true

	belongs_to :invitation
end

DataMapper.finalize

callerID = validate_caller_id(agi.callerid)
agi.noop("validated id " + callerID)

caller = Invitation.last(:usernumber => callerID)

if caller
	user_pin = agi.wait_for_digits(ask_for_pin, nil, 4)
	invite = Invitation.last(:uid => user_pin.digits) 
	if invite
		agi.noop("Pin: " + user_pin.digits)

		nums = invite.numbers
		nums.each_with_index do |num, i|
			agi.noop("Row: #{i+1}  value: #{num.phonenumber}")
		end
	end
end

# @invite = Invitation.last
# nums= @invite.numbers
# nums.each_with_index do |num, i|
#   puts "Row: #{i+1}  value: #{num.phonenumber}"
# end

# if agi.caller
# puts agi.callerid

# agi.streamfile("vm-extension")