require File.dirname(__FILE__) + '/app.rb'

before do 
  s = request.path_info
  s[/^\/~(\w)+\/sinatra\/[^\/|?]+/i] = ""
  request.path_info = s
end

run Sinatra::Application
