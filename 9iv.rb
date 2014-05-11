$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"


require 'iv'
require 'misc'
require 'DBI'
require "watir"
ie= Watir::IE.new

=begin
require 'date'
d1 = Date.new(y=2008,m=3,d=22)
puts d1
=end


rfile="c://temp//9iv.sid"
file = File.new(rfile, "r")

counter = 1

while (line = file.gets)

line=line.gsub(/\n/,"")
 
 
 print "\n\n"
 puts "-----------------------"
 puts "     SID #{line}     "
 puts "-----------------------"
 
 Iv.SaveID(ie, "#{line}")
  
	counter = counter + 1
end


#Iv.SaveID(ie, "5730")

















