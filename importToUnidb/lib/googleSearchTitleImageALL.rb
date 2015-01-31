# -*- coding: utf-8 -*-

def usage()
  puts "$0 <startid> [endid]"
  exit
end

#######################
##
##  Search softname image on google, then save image to local and  insert first? result to unidb as title image
##
##
########################

$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
$LOAD_PATH << "c:/ruby_project/lib"



require "misc"
require 'DBI'
require "osc"


if ARGV[0].nil?
startid=Misc.getMaxMyIDHasTitleImage()
else
startid=ARGV[0].to_i
end

puts "start from id #{startid}"

#puts soft100PageArr
if ARGV[1].nil?
  puts "end by all of the unidb"
  sql="SELECT `myID` FROM `main` WHERE `myID` > #{startid}"
else 
  endid=ARGV[1].to_i
  puts "end by ${endid}"
  sql="SELECT `myID` FROM `main` WHERE `myID` > #{startid} AND `myID` < #{endid}"
end




arr=Misc.dbshowArray(sql)
threads = []

arr.each {|x| 
puts x
# threads << Thread.new{Misc.googleSearchTitleImg(x.to_s)}
 
 Misc.googleSearchTitleImg(x.to_s)

 #threads << Thread.new{puts "hi#{x}"}
 
  }
 
  
 # p 2
 # p threads
 # threads.each { |aThread| p aThread.status;   }



#Misc.googleSearchTitleImg("308")
