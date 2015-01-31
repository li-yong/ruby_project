# -*- coding: utf-8 -*-
$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
$LOAD_PATH << "c:/ruby_project/lib"
 
require 'misc'
require 'Qunarlib'



# CONFIG
gorange=(30..33).to_a # can be leave from tomorrow to next 10 days
stayrange=(7..8).to_a # can stay  tocity  in (3 - 7 ) days
from="wlmq"
to="sh"


#get which days need to check go , and which days need to check back.
backrange=((gorange[0]+stayrange[0])..(gorange[-1]+stayrange[-1])).to_a
leaveday=[]
backday=[]
gorange.each { |x| leaveday << Qunarlib.nextNdayfromToday(x) }
backrange.each { |x| backday << Qunarlib.nextNdayfromToday(x) }

p "leave:" +leaveday.to_s
p "back:" +backday.to_s

# start to check leave price
leave_day_pricemap={}
leaveday.each { |day| leave_day_pricemap[day]=Qunarlib.insertdayprice(day,from,to).to_i }
lowestpricearray=leave_day_pricemap.sort_by { |k,v| v }[0]
rtnsubject=lowestpricearray[0].to_s + " -> " + lowestpricearray[1].to_s  # "2010-03-13 -> 750"
rtnsubject=rtnsubject+" #{from}->#{to}"
rtnbody=""
leave_day_pricemap.each{|x| rtnbody=rtnbody+"\n"+ x[0].to_s + " -> "+  x[1].to_s }
 
p rtnstring # "2010-03-13 -> 750  wlmq->sh"
Misc.send_email("","", "", "sunraise2005@gmail.com", "myself", rtnsubject, rtnbody)


# start to check back price
 #backday.each {  |day| Qunarlib.insertdayprice(day,to,from) }

