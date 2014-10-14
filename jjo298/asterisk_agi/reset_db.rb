#!/usr/bin/ruby
require 'data_mapper'   #for database integration

#set up database
DataMapper.setup(:default, {
 :adapter  => 'yaml',
 :path     => '/home/jjo298/sinatra/missed-calls/db'})

 #keypress model for database interaction
 class Keypress
  include DataMapper::Resource
  property :id, 			Serial
  property :last_digit, 	String, :required => true
  property :last_callerid,	String
end

# Automatically create the tables if they don't exist
DataMapper.auto_upgrade!
# Finish setup
DataMapper.finalize
keypress = Keypress.first_or_create({:id => 1} , { :last_digit => '-' })
keypress.update(:last_callerid => ' - ', :last_digit => ' - ')