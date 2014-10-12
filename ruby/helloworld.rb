#!/usr/bin/env ruby
puts "hello world!"

my_string = "Hello"
puts my_string

# ruby is weakly typed
a_number = 123
another_number = 123.423

boo = true

nothing = nil

an_array = [1, 2, 3, "hello this fucking array"]

# hash = dictionary = json
a_hash = {}

puts an_array

# everything in ruby is an object

10.times do |num|
	puts num
end

an_array.each do |thing|
	puts thing
end

a = 100000 if a_number = 123.45
puts a

unless a_number > 100
	puts "this is tiny"
else
	puts "this is big"
end

