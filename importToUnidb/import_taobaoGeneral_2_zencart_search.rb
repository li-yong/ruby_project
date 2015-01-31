$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
$LOAD_PATH << "c:/ruby_project/lib"



#######################

h=Hash.new
#Women's->HandBag->chanel hand bag
h["105"]=["c:/tmp/cat105_chanelWomanBag.txt","http://s.taobao.com/search?q=chanel+%C5%AE%B0%FC"]

#Women's->HandBag->gucci hand bag
h["102"]=["c:/tmp/cat102_gucciWomanBag.txt","http://s.taobao.com/search?q=gucci+%C5%AE%B0%FC&keyword=&commend=all&ssid=s5-e-p1&search_type=item&atype=&tracelog="]

#Women's->HandBag->hermes hand bag
h["104"]=["c:/tmp/cat104_hermesWomanBag.txt","http://s.taobao.com/search?q=hermes&cat=50006842&commend=all&style=grid&ssid=s5-e&ppath=21541:42521&cps=yes&from=compass&navlog=compass-35-p-21541:42521"]

#Women's->HandBag->lv hand bag
h["103"]=["c:/tmp/cat103_lvWomanBag.txt","http://s.taobao.com/search?q=lv+%C5%AE%B0%FC&keyword=&commend=all&ssid=s5-e-p1&search_type=item&atype=&tracelog="]

#Women's->HandBag->other brands hand bag
h["30"]=["c:/tmp/cat30_otherWomanBag.txt","http://s.taobao.com/search?q=chanel+%C5%AE%B0%FC"]

#Men's > Accessories > watch > Patek Philippe Watch
h["108"]=["c:/tmp/cat108_manpaterkphilippeWatch.txt","http://s.taobao.com/search?q=Patek+Philippe+%C4%D0+%B1%ED&sort=sale-desc"]


#Men's > Accessories > watch > Rolex Watch
h["107"]=["c:/tmp/cat107_manRolexWatch.txt","http://s.taobao.com/search?q=%C0%CD%C1%A6%CA%BF+%C4%D0+%B1%ED&from=rs&navlog=rs-5-q-%C0%CD%C1%A6%CA%BF+%C4%D0+%B1%ED"]


#Men's > Accessories > watch > Vacheron Constantin Watch
h["109"]=["c:/tmp/cat109_manVacheronConstantinWatch.txt","http://s.taobao.com/search?q=%BD%AD%CA%AB%B5%A4%B6%D9+%C4%D0+%B1%ED&cat=50005700&ppath=20000%3A46496%3B22340%3A46498%3B4423756%3A3269309&uniq=seller&cps=yes&pi=main&filter=reserve_price%5B320.01%2C2650%5D"]

## topsell_
#h["110"]=["c:/tmp/cat110_mantopSellWatch.txt","http://top.taobao.com/level3.php?cat=TR_PS&level3=50005700&from=search_result_query&toprankid=1288257009_SB_GJC_GZ_T&up=false"]



def usage(h)
  puts "usage:"
  #puts "$0 <# of last soft100page want to processed>"
  #puts "  eg. $0  5 will download last 5 pages(500softs) "
  #puts  "or "
  puts "$0 $catID $parseFirstNPage(default is 5)"
  puts   "eg. $0 102 3"
  puts "====="
  h.each {|key, value| 
  
  filename=value[0]
  puts "#{key} is #{filename}" }


  exit
end


if ARGV[0].nil?
  usage(h)
  return
end

require 'iv'
require 'misc'
require 'DBI'
require "watir"
require "verycd"
load "taobaoGeneral.rb"





 catID=ARGV[0].to_s if !ARGV[0].nil?
 
 parseFirstNPage="5"
 parseFirstNPage=ARGV[1].to_s if !ARGV[1].nil?
 
 puts "parsing first #{parseFirstNPage} pages of category #{catID}"
  




filename=h[catID][0]
urlBase=h[catID][1]

 


#get url of  first 3 search pages 
pagesArr=TaobaoGeneral.getLinkArrOfFirstXSearchPage(urlBase,parseFirstNPage)

pagesArr.each{|pageurl|
TaobaoGeneral.saveLinkArrOfOneSearchPageToFile(pageurl,filename)
}

puts "tb item links were saved to #{filename}"

