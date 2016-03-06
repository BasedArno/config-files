#!/usr/bin/env ruby

require 'json'

# Get workspaces on a particular output
workspaces = JSON.parse `i3-msg -t get_workspaces`
workspaces.select! {|ws| ws['output'] == "DisplayPort-1"}

# Build string of names
names = workspaces.map {|ws| ws['name']}
names = names.inject("") {|acc, e| e + "\n" + acc}

result = `echo "#{names}" | dmenu -p "Select Workspace:"`

if names.include? result
  exec "i3-msg -t command workspace #{result}"
else
  system "i3-msg -t command workspace new"
  exec "i3-msg -t command rename workspace to #{result}"
end
