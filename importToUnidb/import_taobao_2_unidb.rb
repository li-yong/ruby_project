$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
$LOAD_PATH << "c:/ruby_project/lib"


def usage()
  puts "usage:"
  #puts "$0 <# of last soft100page want to processed>"
  #puts "  eg. $0  5 will download last 5 pages(500softs) "
  #puts  "or "
  puts "$0 $start $end"
  puts   "eg. $0 0 5"
  puts "  will download pages from 1 to 6."
  puts "or $0 will download from page 1 to end"
  exit
end




require 'iv'
require 'misc'
require 'DBI'
require "watir"
require "verycd"
require "taobao"
ie= Watir::Browser.new


 startPageID=1
 startPageID=ARGV[0].to_i if !ARGV[0].nil?

 
 endPageID="end of totall pages"
 endPageID=ARGV[1].to_i if !ARGV[1].nil?
 
 puts "processing from #{startPageID} to #{endPageID}"
  

#######################
urlBase="http://macbookpro.taobao.com/?search=y&orderType=hotsell&categoryName=&viewType=grid&price1=&price2=&scid=0&keyword=&old_starts=&categoryp=&pidvid=&isNew=&ends=&baobei_type=&pageNum="


ie.goto(urlBase+"1")
bottomPanelLinks=ie.div(:class,"page-bottom").links
totalPages=bottomPanelLinks[bottomPanelLinks.length-1].text


endPageID=totalPages
endPageID=ARGV[1].to_i if !ARGV[1].nil?
puts "Confirm again: processing from #{startPageID} to #{endPageID}"



(startPageID.to_i..endPageID.to_i).each{|x| 

thisPageURL=urlBase+x.to_s
ie.goto(thisPageURL) 
5.times {ie.refresh if !(ie.ul(:class,"shop-list").exist?)}

puts "=== We are now at page "+ x.to_s+" of total "+ endPageID.to_s
thisPageItemsArray=Taobao.getthisPageItemsArray(ie,thisPageURL)
Taobao.handleOnePage(thisPageItemsArray,x.to_s)

}

 
