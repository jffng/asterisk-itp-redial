#!/usr/bin/ruby

require 'ruby-agi'

agi = AGI.new

invites_location = "/home/jjo298/public_html/invitations/"

id = agi.calleridnumber

filepath = invites_location + id

agi.noop(filepath)

agi.stream_file(invites_location+id)