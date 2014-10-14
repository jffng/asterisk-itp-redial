require 'sinatra'
require 'rubygems'
require 'data_mapper'
require 'fileutils'

DataMapper.setup(:default, {
	:adapter => 'yaml',
	:path => '/home/jjo298/sinatra/missed-calls/db'
	})

	class Keypress
		include DataMapper::Resource
		property :id, 				Serial
		property :last_digit, 		String, :required => true
		property :last_callerid, 	String
end

get '/' do
  erb :index
end

get '/digitinfo' do
	keypress = Keypress.get(1)
	puts keypress
	"#{keypress.last_callerid},#{keypress.last_digit}"
end

