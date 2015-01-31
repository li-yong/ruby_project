


def funcerr()
puts "$0 request 36 50 -- search from category 36..50 and send linkexchange request"
puts "$0 job 1 -- gather html link code of exchanged."
puts "$0 job 2 -- update op's link code to my site (current is manual)"
puts "$0 job 3 -- input my link page and submit"

puts "     "
exit
end



task=ARGV[0]

if (task != "request") and (task !="job")
  funcerr()
  
end


$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
$LOAD_PATH << "c:/ruby_project/lib"

require 'iv'
require 'misc'
require 'DBI'
require "watir"
require "verycd"
require "taobao"


require "lm"


###keep session alive
ieRefreshsession=Watir::Browser.new
Thread.new{LM.makesessionalive(ieRefreshsession)}

if task == "request"
######
## 1.  get category link
## 2. search and send request
#######

startpage=ARGV[1].to_i  #start category
endpage=ARGV[2].to_i  #start category
linkarr=LM.getCatLink
endpage=linkarr.length if endpage == 0
#linkarr[startpage..endpage].each{|url|thread.new{puts "=====starpage "+linkarr.index(url).to_s;  load "lm.rb"; LM.scanAndsentrequest(url) }}
threads = []
linkarr[startpage..endpage].each{|url|
  currentcatID=linkarr.index(url).to_s;
  #puts "=====startpage "+$currentcatID;  
  load "lm.rb"; 
  threads << Thread.new{LM.scanAndsentrequest(currentcatID,url)} 

  }
  
  threads.each { |aThread|  aThread.join }
  ieRefreshsession.close

  

 
elsif task == "job"

#############
# handle current job
#############

  
jobstage=ARGV[1].to_i 
if jobstage == 1 
  puts "$0 job 1 -- gather html link code of exchanged."
  LM.currentjob("1")
elsif jobstage == 2
  puts "$0 job 2 -- update op's link code to my site (current is manual)"
elsif jobstage == 3
 puts "$0 job 3 -- input my link page and submit"
 LM.currentjob("3")
 
 
end #if jobstage == 1 


  

end






