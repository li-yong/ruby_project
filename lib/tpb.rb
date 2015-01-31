module Tpb
$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
require "misc"
require "iv"
require "watir"

require "misc"
require 'DBI'
require "osc"
require "iv"
require "cmm"


## retunrn 0 if the tpbsid not existed in unidb
                  def Tpb.hasTpbSid(tpbsid)
                    sql=   "SELECT count(*) from `main` WHERE  `softuid`=#{tpbsid} and `site`=\"tpb\" "
                    Misc.dbshow(sql)
                    
                  end #def Tpb.hasTpbSid(tpbsid)



def Tpb.saveSID(sid)
  softid=sid.to_s
  newMyID=Misc.getNewMyID()

  url= "http://thepiratebay.org/torrent/#{softid}/"  
#  ie = Watir::Browser.start(url)
 ie = Watir::Browser.new
 Misc.cleanIE
  Cmm.launchIEwithTimeout(ie, url, 10)
  (1..5).each{ |x|  
  if !ie.div(:id,"details").exists?
    ie.refresh 
	sleep 5
	puts "refresh IE "+x.to_s+" times since \'details\' div not exist"
  end
	
  }

  
  if ie.title.include?("Not Found")
    puts "torrent #{softid} not existed in site tpb, skip"
    return
  end
  




softname=ie.div(:id,"title").text.gsub(/\[.*\]/,"")
softname=Iv.softnameProcess(softname)
softname=Misc.txt2Sql(softname)
#ryan todo handle softname here



 


 if Misc.hasSoftName(softname).to_s !="0"
   puts "softname "+ softname + " already in unidb, skip"
   return 
 end  
 
 
 
maintable= ie.div(:id,"details")


ddarr=[]
 d=maintable.dds
 d.each{|x|;ddarr << x.text;}

dtarr=[]
 t=maintable.dts
t.each{|x|;dtarr << x.text;}

if ddarr.length==dtarr.length
dhash={}
 (0..ddarr.length-1).each{|x|; dhash[dtarr[x]]=ddarr[x]}
end



 
 
 
 
 
 




category=dhash["Type:"]
fileCount=dhash["Files:"]
sizeall=dhash["Size:"]
regDate=dhash["Uploaded:"]
quality=dhash["Quality:"]
comments=dhash["Comments:"]
seeders=dhash["Seeders:"]
leechers=dhash["Leechers:"]





sizeNumber=sizeall.split()[0]
sizeUnion=sizeall.split()[1]

sizeUnion="KB" if sizeUnion=="KiB"
sizeUnion="MB" if sizeUnion=="MiB"
sizeUnion="GB" if sizeUnion=="GiB"



descHtm=maintable.div(:class,"nfo").html
desctxt=maintable.div(:class,"nfo").text
descLinks=maintable.div(:class,"nfo").links

#remove tpb links in description html
descLinks.each { |x| 
linkhtml=x.html
if linkhtml.downcase.include?("torrent") or linkhtml.downcase.include?("thepiratebay")
  descHtm=descHtm.gsub(/#{linkhtml}/,"")
end
}



descHtm=Misc.removeKW(descHtm)
#p "=============1========="
#p descHtm[0..100]

#descHtm=Iv.descHtmlProcess(descHtm)
#p "==========2========="
#p descHtm[0..100]

  
desctxt= Misc.wordProcess(desctxt)
desctxt= Iv.descTextProcess(desctxt)

ie.close
  
  puts "softid is: "+softid
  puts "softname is: "+softname
  puts "category is: "+category
  puts "regDate is: "+regDate
  puts "sizeNumber is: "+sizeNumber
  puts "sizeUnion is: "+sizeUnion
#  puts "desc is"+descHtm
  




sqlD="INSERT INTO `description` ( `myID` , `html` , `txt` ) "
 sqlD=sqlD+"VALUES ("
 sqlD=sqlD + \
      newMyID +",'"  \
      + Misc.txt2Sql(descHtm)+"','"  \
      + Misc.txt2Sql(desctxt)+"'"  \
      +"); "


sqlM="INSERT INTO `main` \
    ( `myID` , `site` , `category` , `softuid` , `softname` , `register` , `sizevalue` , `sizeunion` , `filecount` , `adddaytime` ) "
 sqlM=sqlM+"VALUES ("
 sqlM=sqlM + \
      newMyID +",'"  \
      + "tpb"+"','"  \
      + Misc.txt2Sql(category)+"','"  \
      + Misc.txt2Sql(softid.to_s)+"','"  \
      + Misc.txt2Sql(softname)+"','"  \
      + Misc.txt2Sql(regDate)+"','"  \
      + Misc.txt2Sql(sizeNumber)+"','"   \
      + Misc.txt2Sql(sizeUnion)+"','"  \
      + Misc.txt2Sql(fileCount.to_s)+"','"   \
      + Misc.datenow()+"'" \
      +"); "
      

Misc.dbprocess(sqlM) 

Misc.googleSearchTitleImg(newMyID)
Misc.insert2featured(newMyID)

if Misc.hasmyIDDescription(newMyID).to_s=="0".to_s
Misc.dbprocess(sqlD)
else
  puts "id "+newMyID.to_s+"have already in table Description"
end #if !self.hasmyIDDescription(newMyID)

  
 
      

ie.close

end  #def Tpb.saveSID(sid)




def Tpb.saveTorrent(softid)
  
  softid=softid.to_s
  ie = Watir::Browser.new
  ie.goto "http://thepiratebay.org/torrent/#{softid}"
  if !ie.title.include?("Not Found") and !ie.text.include?("aka 404")

     torlink=ie.link(:title,"Download this torrent")
     torname=torlink.href.split("/")[-1]
     torSavePath="c:\\tmp\\"
     torSaveName="tpb#{softid}_"+Iv.cygwindlname(torname.gsub(".torrent",""))+".torrent" 
     absFilePath=torSavePath+torSaveName
     
     
#     load "misc.rb"
     torlink.click_no_wait
     Misc.save_httpFile(absFilePath)
     puts "torrent was saved to #{absFilePath}"
     ie.close
     return "#{absFilePath}"
   else
     #ie.close
     puts "download torrent was Not success, maybe No torrent with ID"  
     return "error"
     
   end  #!ie.text.include?("Error") and !ie.text.include?("No torrent with ID")
  
end #def Tpb.saveTorrent(softid) 




end #end of the module