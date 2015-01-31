# -*- coding: utf-8 -*-
module Qunarlib  # Manufactor Map
require 'watir'
require 'DBI'

 


  
def Qunarlib.citymap(cityname)
 city = {}
 
 city["sh"]="%e4%b8%8a%e6%b5%b7"
 city["wlmq"]="%e4%b9%8c%e9%b2%81%e6%9c%a8%e9%bd%90"
 city["shanghai"]="%e4%b8%8a%e6%b5%b7"
 city["beijing"]="%e5%8c%97%e4%ba%ac"
 city["jiuzhaigou"]="%e9%bb%84%e9%be%99"
 city["kunming"]="%e6%98%86%e6%98%8e"
 city["shengyang"]="%e6%b2%88%e9%98%b3"
 city["chongqing"]="%e9%87%8d%e5%ba%86"
 city["xianggang"]="%e9%a6%99%e6%b8%af"
 city["qingdao"]="%e9%9d%92%e5%b2%9b"
 city["dalian"]="%e5%a4%a7%e8%bf%9e"
 city["dongjing"]="%e4%b8%9c%e4%ba%ac"
 city["xiameng"]="%e5%8e%a6%e9%97%a8"
 city["xini"]="%e6%82%89%e5%b0%bc"
 city["mangu"]="%e6%9b%bc%e8%b0%b7"
 city["nanjing"]="%e5%8d%97%e4%ba%ac"
 city["hangzhou"]="%e6%9d%ad%e5%b7%9e"
 city["chengdu"]="%e6%88%90%e9%83%bd"
 city["wulumuqi"]="%e4%b9%8c%e9%b2%81%e6%9c%a8%e9%bd%90"
 city["xinjiapo"]="%e6%96%b0%e5%8a%a0%e5%9d%a1"
 city["xini"]="%e6%82%89%e5%b0%bc"
 city["sanya"]="%e4%b8%89%e4%ba%9a"
 city["haikou"]="%e6%b5%b7%e5%8f%a3"
 city["xian"]="%e8%a5%bf%e5%ae%89"
 city["changsha"]="%e9%95%bf%e6%b2%99"
 city["wuhan"]="%e6%ad%a6%e6%b1%89"
 city["kashi"]="%E5%96%80%E4%BB%80"


 return city[cityname]
end  #def Qunarlib.citymap(cityname)





def Qunarlib.insertdayprice(startday,flightfrom,flightto)
  
    startday=startday  
    flightfrom_code = self.citymap(flightfrom)
    flightto_code =  self.citymap(flightto)
    
    
    url="http://flight.qunar.com/site/oneway_list.htm?searchDepartureTime="
    url=url+startday.to_s
    url=url+"&arrivalTime=&searchDepartureAirport="+flightfrom_code
    url=url+"&searchArrivalAirport="
    url=url+flightto_code
    url=url+"&searchType=OneWayFlight&startSearch=true&from=qunarindex"



   ie = Watir::Browser.new
   ie.goto(url)
      
  (1..10).each {   print '.' ; sleep 1 } 
   
 
   base=ie.span(:xpath,"//span[@class='disc']/ ../")
 
   
 
   todayprice= base.span(:index,1).text[0].chr+"."+base.span(:index,1).text[2].chr
   todaydiscount=todayprice.to_f/orgprice.to_f
 
    
    
  
  puts flightfrom +" -> "+ flightto+","+  startday+", $"+  todayprice.to_i.to_s+", "+   todaydiscount.to_s
  ie.close   
  return todayprice
end #def Qunarlib.insertdayprice(startday,flightfrom,flightto)



end #module Qunarlib