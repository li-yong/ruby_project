$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
$LOAD_PATH << "c:/ruby_project/lib"
#require "watir"
require "misc"
require 'DBI'
require "osc"



maxid=Osc.dbshow("SELECT max( `myID` )FROM `products` WHERE 1 ")
maxid="0" if maxid.nil?
if ARGV[0].nil?
  sql="SELECT `myID` FROM `main` WHERE `myID` > #{maxid}"
else
  sql="SELECT `myID` FROM `main` WHERE `myID` >= #{ARGV[0]}"
  puts sql
end

arr=Misc.dbshowArray(sql)

arr.each {|x| Osc.insertMyID(x) }

