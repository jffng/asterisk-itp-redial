#!/usr/bin/ruby

require 'data_mapper'

DataMapper.setup(:default, {
	:adapter => 'mysql',
	:host => 'localhost',
	:username => 'root',
	:password => '',
	:database => 'emoji_test'
})

class Recording
	include DataMapper::Resource

	property :id, Serial
	property :file_path, String, :required => true
	property :rating, Integer

	belongs_to :emojiphrase
end

class Emojiphrase
	include DataMapper::Resource

	property :id, Serial
	property :phrase, String, :required => true
	property :emoji, String, :required => true

	has n, :recordings
end

DataMapper.auto_upgrade!
DataMapper.finalize

File.open('phrases.txt') do |file_handle|
	file_handle.each_line do |line|
		Dir.foreach('emojis') do |fname|
			next if fname == '.' or fname == '..'
			emojiphrase = Emojiphrase.first_or_create( { :phrase => line.tr("\n", '', :emoji => fname } )
		end
	end
end