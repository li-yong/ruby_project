$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
$LOAD_PATH << "c:/ruby_project/lib"
require "misc"
require "iv"


#require "watir"
require "misc"
require 'DBI'
require "osc"
require "iv"
require "cmm"
require "cmm2"
require "bitme"

frompage=ARGV[0].to_i
topage=ARGV[1].to_i


ie = Watir::Browser.new

for page in  (frompage..topage)  

ie.goto "http://www.bitme.org/browse.php?page="+page.to_s


idarr=[]


for i in 2..ie.table(:index,22).row_count

link= ie.table(:index,22).row(:index,i)[2].link(:index,1).href
link= link.split("=")[1]
link= link.split("&")[0]
link= link.strip
puts link 
idarr << link
end #for i in 2..filetable.row_count


idarr.each { |i| 
#if !i.src.to_s.include?("bitme")
#puts i.src.to_s 
puts "---- Process sid "+i.to_s+" ----"

if (Misc.dbshow("SELECT count(*) FROM `main` WHERE `site`=\"bitme\" and `softuid`="+i.to_s)=="0")
Bitme.saveSID(i) 
else
  puts "id "+i.to_s+" have existed for bitme in unidb"
end


#end
}

ie.close
end #for page in  (frompage..topage-1)  
