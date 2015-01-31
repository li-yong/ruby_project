$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
$LOAD_PATH << "c:/ruby_project/lib"

require 'iv'
require 'misc'
require 'DBI'
require "watir"
ie= Watir::Browser.new
require 'optparse'

#--------- Start of parse option
options = {}

optparse = OptionParser.new do|opts|

   opts.on( '-h', '--help', 'Display this screen' ) do
     puts opts
     exit
   end
  

   options[:overwrite] = false
   opts.on( '-o', '--overwrite ', 'overwrite if the item already in unidb' ) do|overwrite|
     options[:overwrite] = true
   end


  
end

optparse.parse!
#--------- End of parse option

=begin
require 'date'
d1 = Date.new(y=2008,m=3,d=22)
puts d1
=end

#removed, because the following rb code will not waiting this bat file finished.
#cmd = "C:\\script\\9iv_gensid.bat"
#system (cmd)

rfile="c:\\temp\\9iv.sid"
file = File.new(rfile, "r")

counter = 1

while (line = file.gets)

line=line.gsub(/\n/,"")
 
 
 print "\n\n"
 puts "-----------------------"
 puts "     SID #{line}     "
 puts "-----------------------"
 
 Iv.SaveID(ie, "#{line}",options[:overwrite])
  
	counter = counter + 1
end

ie.close

#Iv.SaveID(ie, "5730")

















