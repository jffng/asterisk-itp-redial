require 'data_mapper'

DataMapper.setup(:default, {
	:adapter => 'mysql',
	:host => 'localhost',
	:username => 'root',
	:password => '',
	:database => 'emojiphrase'
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