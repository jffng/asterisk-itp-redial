#! usr/bin/ruby

require 'ruby-agi'

agi = AGI.new
welcome = "~/asterisk_sounds/subwaystories/welcome"
which_sketch = "~/asterisk_sounds/subwaystories/which_sketch"
recordings_location = "~/asterisk_sounds/subwaystories/recordings/"
invalid_extension = "~/asterisk_sounds/subwaystories/invalid_extension"

	#We got a result from the database, play welcome message

agi.stream_file(welcome)
sleep(1)
#pause 1 second to let stream file bug pass

whereto = agi.wait_for_digits(which_sketch, 10000, 1)

if(whereto.digits < 6)
	record_file = recordings_location + whereto.digits + '_' + Time.now
	
	agi.noop("Keypress: " + whereto.digits)

	agi.record_file(record_file, "WAV", "0123456789#*", 10000, true)

else
	agi.stream_file(invalid_extension)
	agi.hangup()
end