$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
$LOAD_PATH << "c:/ruby_project/lib"

require 'net/http'
require 'uri'
require 'dbi'
load 'misc.rb'
load 'wpimprt.rb'

#--------- Start of parse option
options = {}

optparse = OptionParser.new do|opts|

   opts.on( '-h', '--help', 'Display this screen' ) do
     puts opts
     exit
   end
  

   options[:startMyID] = nil
   opts.on( '-s', '--startMyID ', 'start myid of valider' ) do|startMyID|
     options[:startMyID] = startMyID
   end
 
end

optparse.parse!



if options[:startMyID].nil? 
        puts "missing --startMyID in input command"
        exit
else
    startMyID= options[:startMyID]
end
     
     
     

#--------- End of parse option



Wpimprt.removeBrokenLinkPost(startMyID)



