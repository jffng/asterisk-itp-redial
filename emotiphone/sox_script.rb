#!/usr/bin/ruby

fnames = Dir["recordings/*.WAV"]

fnames.each {

}

Dir.foreach('recordings') do |fname|
	next if fname=='.' or fname=='..'
	infile = "recordings/#{fname}"
	puts infile
	cmd = "sox #{infile} recordings/tmp.WAV silence 1 0.1 1%"
	move = "mv recordings/tmp.WAV #{infile}"
	# puts cmd
	system( cmd )
	system( move )
end