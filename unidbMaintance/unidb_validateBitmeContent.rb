#this script is used to validate bitme, if the bitme does not host the torrent, it will remove the sid from unidb and zenc_bitme 

# it will parse all unidb.myid, if the myid stand for bitmeid is no longer hosted in bitme.org, remove it from the unidb and zencart.bitme.
# then it checking if torrent file was saved to local, if not, save it to local and update unidb.dlpathmap
# then it checking if unidb.dlpathmap has the records, if not, update saved torrent to the table.

#ryan, 2011/07/14


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

 
 
#valide links in table dlpathmap. update 0 or 1 for valid column.
Misc.validateBitme(startMyID)



