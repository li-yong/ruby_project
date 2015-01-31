$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
$LOAD_PATH << "c:/ruby_project/lib"


def usage()
  puts "usage:"
  puts "$0 <# of last soft100page want to processed>"
  puts "  eg. $0  5 will download last 5 pages(500softs) "
  puts  "or "
  puts "$0 $start $end"
  puts   "eg. $0 0 5"
  puts "  will download pages from 1 to 6."
  exit
end




require 'iv'
require 'misc'
require 'DBI'
require "watir"
require "verycd"
ie= Watir::Browser.new




if ARGV[0].nil?
  lastpage=1
  puts "download LAST PAGE of verycd soft category"
else
  lastpage=ARGV[0].to_i
end




soft100PageArr=Verycd.returnSoftRootPages(ie, "http://www.verycd.com/archives/software/")
#puts soft100PageArr
if ARGV[1].nil?
soft100PageArr=soft100PageArr.last(lastpage)
else  
endpage=ARGV[1].to_i
soft100PageArr=soft100PageArr[lastpage..endpage]
end
  


soft100PageArr.each { |x| 

   #puts "\n get SID in Soft100Page "+x +"\n";
   softArr=Verycd.returnSids(ie, x) 
   
   softArr.each { |y|
     #puts "\n parsing SID "+ y.to_s +" Data\n"
     puts " "
     puts "----start VeryCD ID "+y +" on page "+x+"-----"
  
 # puts Misc.hasID(y,"verycd").to_s
 # exit
   if (Misc.hasID(y,"verycd").to_s=="0")  
     sidIE=Watir::Browser.new
     
     Verycd.parseItem(sidIE,y)
     sidIE.close
     else
       puts "ID "+y+" for verycd already existed in unidb"
     end
     
     } #softArr.each { |y|
   
   
   } #soft100PageArr.each { |x| 



