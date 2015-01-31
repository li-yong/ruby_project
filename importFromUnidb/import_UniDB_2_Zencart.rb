$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
$LOAD_PATH << "c:/ruby_project/lib"

require 'misc'
require 'DBI'
require "osc"
require "zencart"
require 'optparse'


##############
##  outputs: c:/tmp/2010-09-15.sql_zencart
##
##############

#--------- Start of parse option
options = {}

optparse = OptionParser.new do|opts|

   opts.on( '-h', '--help', 'Display this screen' ) do
     puts opts
     exit
   end
  
  
   options[:startId] = nil
   opts.on( '-s', '--startid ', 'start id of importer' ) do|startId|
     options[:startId] = startId
   end
  
   options[:site] = nil
   opts.on( '-t', '--site ', 'import this site\'s entry in unidb to zenc' ) do|site|
     options[:site] = site
   end
  
end

optparse.parse!



if options[:site].nil? 
        puts "missing site in input command"
        exit
else
    sqlsitepart=" and `site`= \"#{options[:site]}\""
    odbc="zencart.#{options[:site]}"
    
    
end
#--------- End of parse option



maxid=Zencart.getMaxMyid(odbc)
maxid="0" if maxid.nil?
if options[:startId].nil?
  sql="SELECT `myID` FROM `main` WHERE `myID` > #{maxid} " + sqlsitepart
else
  sql="SELECT `myID` FROM `main` WHERE `myID` >= #{options[:startId]}" + sqlsitepart
end


puts sql


arr=Misc.dbshowMultiArrayCommon("unidb",sql)


arr.each {|x| Zencart.insertMyID(odbc,x[0]) }

