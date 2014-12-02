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
	property :has_recording, Boolean, :required => true

	has n, :recordings
end

DataMapper.auto_upgrade!
DataMapper.finalize

emoji = Emojiphrase.first(:has_recording=>false)

puts "#{emoji.emoji}, #{emoji.phrase}"

@sock.puts "id:#{@uniqueid},event:keypress,value:#{result.digit}"




# emoji = Emojiphrase.all(:emoji=>'4-smiling-face-with-smiling-eyes.png', :phrase=>'Wow. You look so good.')

# rec = Recording.create({ :file_path => '/some/random/path/#{random_path}' })

# for e in emoji
# 	# e.recordings << rec
# end