#!/usr/bin/ruby

require 'rubygems'
require 'ruby-agi'
require 'data_mapper' 

agi = AGI.new

DataMapper.setup(:default, {
 :adapter  => 'yaml',
 :path     => '/home/jjo298/sinatra/missed-calls/db'})

	class Keypress
		include DataMapper::Resource
		property :id,				Serial
		property :last_digit, 		String, :required => true
		property :last_callerid,	String
end

DataMapper.auto_upgrade!
DataMapper.finalize

mSequence = ['1','2','3','4','5','6','7','8','9'] #.shuffle

current = mSequence.shift

keypress = Keypress.first_or_create( {:id => 1}, {:last_digit => '-'})

keypress.update( :last_callerid => agi.callerid )

agi.stream_file("vm-extension")


while true
	result = agi.wait_for_digit(-1)
	agi.stream_file('#current')
	if (result.digit === current)
		keypress.update(:last_digit => result.digit)
		current = mSequence.shift
	else
		break
	end
end