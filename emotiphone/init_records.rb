#!/usr/bin/ruby

require 'data_mapper'
require_relative 'model.rb'

File.open('phrases.txt') do |file_handle|
	file_handle.each_line do |line|
		Dir.foreach('emojis') do |fname|
			next if fname == '.' or fname == '..' or fname == '.DS_Store'
			emojiphrase = Emojiphrase.first_or_create( { :phrase => line.tr("\n", ''), :emoji => fname, :has_recording => false } )
		end
	end
end