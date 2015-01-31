# -*- coding: utf-8 -*-
$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
$LOAD_PATH << "c:/ruby_project/lib"

require 'misc'




require 'optparse'

#--------- Start of parse option
options = {}

optparse = OptionParser.new do|opts|

opts.on( '-h', '--help', 'Display this screen' ) do
  puts opts
  exit
end


options[:site] = nil
opts.on( '-s', '--site ', 'site that all records will be removed from unidb' ) do|site|
options[:site] = site
end



end

optparse.parse!
#--------- End of parse option
if options[:site].nil? 
puts "missing --site in input command, using -h show help"
exit 
end



Misc. delete_from_db_by_vendor(options[:site])