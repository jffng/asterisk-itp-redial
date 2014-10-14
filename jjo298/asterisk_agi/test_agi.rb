#!/usr/bin/ruby


require 'ruby-agi'
require 'data_mapper'   #for database integration

agi = AGI.new #new agi object

#set up database
DataMapper.setup(:default, {
 :adapter  => 'yaml',
 :path     => '/home/jjo298/sinatra/missed-calls/db'})

 #keypress model for database interaction
 class Keypress
  include DataMapper::Resource
  property :id, 		Serial
  property :last_digit, 	String, :required => true
  property :last_callerid,	String
end

# Automatically create the tables if they don't exist
DataMapper.auto_upgrade!
# Finish setup
DataMapper.finalize
keypress = Keypress.first_or_create({:id => 1} , { :last_digit => '-' })
keypress.update(:last_callerid => agi.callerid)
# start agi scripting
agi.stream_file("vm-extension")
while true
	result = agi.wait_for_digit(-1) # wait forever
	if result.digit
	   keypress.update(:last_digit => result.digit)
	end
end