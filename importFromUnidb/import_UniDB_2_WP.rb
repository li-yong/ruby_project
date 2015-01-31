$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
$LOAD_PATH << "c:/ruby_project/lib"
#require "watir"
require "misc"
require 'DBI'
require "osc"
require "wpimprt"
require 'optparse'

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
end
     
     
     

#--------- End of parse option

if options[:startId].nil?
	maxid=Wpimprt.dbshow("SELECT max( `myID` )FROM `myid_postid` WHERE 1 ")
	maxid="0" if maxid.nil?
else
  	maxid=options[:startId]
end

 

sql="SELECT `myID` FROM `main` WHERE `myID` > #{maxid} " + sqlsitepart 


arr=Misc.dbshowArray(sql)

arr.each {|x|Wpimprt.insertMyID(x) }
