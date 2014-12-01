#!/usr/bin/ruby

require 'data_mapper'

DataMapper.setup(:default, {
	:adapter => 'mysql',
	:host => 'localhost',
	:username => 'root',
	:password => '',
	:database => 'emoji_test'
})

# class Emoji
# 	include DataMapper::Resource

# 	property :id, Serial
# 	property :name, String, :required => true

# 	has n, :emojiphrases
# 	has n, :phrases, :through => :emojiphrases 
# end

# class Phrase
# 	include DataMapper::Resource

# 	property :id, Serial
# 	property :phrase, String, :required => true

# 	has n, :emojiphrases
# 	has n, :emojis, :through => :emojiphrases
# end

class Recording
	include DataMapper::Resource

	property :id, Serial
	property :file_path, String, :required => true
	property :rating, Integer

	belongs_to :emojiphrase

	# def self.find_all
	# 	all()
	# end

	# def self.highest_rated
	# 	all(:rating.gt => 4)
	# end
end

class Emojiphrase
	include DataMapper::Resource

	property :id, Serial
	property :phrase, String, :required => true
	property :emoji, String, :required => true
	# belongs_to :phrase, :key => true
	# belongs_to :emoji, :key => true

	has n, :recordings
end

DataMapper.auto_upgrade!
DataMapper.finalize

random_path = rand()

emoji = Emojiphrase.all(:emoji=>'4-smiling-face-with-smiling-eyes.png')

# rec = Recording.create({ :file_path => '/some/random/path/#{random_path}' })

for e in emoji
	# e.recordings << rec
	puts e.recordings
end

# emoji.recordings << rec