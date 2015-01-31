$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
$LOAD_PATH << "c:/ruby_project/lib"

require "misc"
load "iv.rb"
require "osc"

if ARGV[0].nil?
  lastItems=50
   puts "check LAST #{lastItems} 9iv item's physcial path"
  sql=" SELECT `myID` from `main` where `site` = \"9iv\" ORDER BY `myID` DESC  LIMIT 0 , #{lastItems} "
else
  lastItems=ARGV[0].to_i
   puts "check LAST #{lastItems} 9iv item's physcial path"
   sql=" SELECT `myID` from `main` where `site` = \"9iv\" ORDER BY `myID` DESC "
end


 
  sql=" SELECT `myID` from `main` where `site` = \"9iv\" ORDER BY `myID` DESC  LIMIT 0 , #{lastItems} "
  print sql
  ivIDarry=Misc.dbshowMultiResults(sql)
  #p ivIDarry;
  ivIDarry.each{|myID| Iv.renamedlPathDirToDBSetting(myID)}










 
