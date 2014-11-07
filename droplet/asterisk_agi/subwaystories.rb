#! usr/bin/ruby

require 'ruby-agi'

agi = AGI.new
welcome = "/root/asterisk_sounds/subwaystories/welcome"
which_sketch = "/root/asterisk_sounds/subwaystories/which_sketch"
recordings_location = "/root/asterisk_sounds/subwaystories/recordings/"
invalid_extension = "/root/asterisk_sounds/subwaystories/invalid_extension"

	#We got a result from the database, play welcome message

# agi.stream_file(welcome)
sleep(1)
#pause 1 second to let stream file bug pass
whereto = agi.wait_for_digits(welcome, nil, 1)

if(whereto.digits)
	time = Time.now.asctime

	record_file = recordings_location + whereto.digits

	agi.noop("Keypress: " + whereto.digits)
	sleep(1)

	agi.record_file(record_file, "WAV", "0123456789#*", 10000, true)
else
	agi.stream_file(invalid_extension)
end