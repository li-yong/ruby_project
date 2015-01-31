module Bitme
$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
require "misc"
require "iv"
require "watir"

require "misc"
require 'DBI'
require "osc"
require "iv"
require "cmm"
require "zencart"

def Bitme.saveTorrentWget(sid)
  softid=sid.to_s
 ie=self.wgetOpenPage(softid)
  
  if !ie.text.include?("Error") and !ie.text.include?("No torrent with ID")
    softname=ie.title.gsub(/^.*Details for torrent/,"").gsub(/"/,"").strip
    softname=Iv.softnameProcess(softname)
    softname=Misc.txt2Sql(softname)
    cygwindlname=Iv.cygwindlname(softname)
    
    btfilename="/cygdrive/c/wamp/www/torrents/bitme/"+softid+"_"+cygwindlname+".torrent"
    btfileverify="c:/wamp/www/torrents/bitme/"+softid+"_"+cygwindlname+".torrent"
    bitmecookie="/cygdrive/c/cygwin/script/Cookie/bitmeCookie.txt"
    
     maintable= ie.table(:index,18)
    dlink = maintable.row(:index,1)[0].link(:index,1).href
    
   
   dlink = dlink.gsub("file:///C:/tmp/","http://www.bitme.org/") if dlink.include?("file:///")
    
    
    puts  "wget will downloading "+dlink[0..60]+"..."
    wgetcmd="c:\\cygwin\\bin\\wget.exe -q  --tries=60 --continue --timeout=2   -U \"Mozilla/5.0 anything else...\" "
    wgetcmd += "--output-document  #{btfilename} "
    wgetcmd += " --load-cookies  #{bitmecookie} "
    wgetcmd += dlink
    system(wgetcmd) 
    
    if File.exist?(btfileverify)
      puts "torrent id #{sid} was saved to "+btfileverify[0..50]+"..., size "+ (File.size(btfileverify)/1024).to_s+" kb"
    else
      puts "torrent id #{sid} FAILED to download, check please."
      puts "try cmd: #{wgetcmd}"
    end
    
  end #if !ie.text.include?("Error") and !ie.text.include?("No torrent with ID")
  ie.close
  
  myid=Misc.getMyidBySoftuid("bitme",softid)  
  protocol="http"  
  server="localhost"
  port="80"
  ppath="torrents"   
  path="bitme/#{cygwindlname}.torrent"
  
  Zencart.updateOrAddDlpathmap(myid,protocol,server,port,ppath,path)

  
end #def Bitme.saveTorrentWget(sid)


def Bitme.wgetOpenPage(sid)
    dlink= "http://www.bitme.org/details.php?id="+sid.to_s.chomp+"&filelist=1#filelist"

    btfilename="/cygdrive/c/tmp/bitmepage.htm"
    btfileverify="c:/tmp/bitmepage.htm"
    bitmecookie="/cygdrive/c/cygwin/script/Cookie/bitmeCookie.txt"
  
   File.delete(btfileverify) if File.exist?(btfileverify)

    puts  "wget will downloading "+dlink[0..60]+"..."
    wgetcmd="c:\\cygwin\\bin\\wget.exe -q  --convert-links --tries=60 --continue --timeout=2   -U \"Mozilla/5.0 anything else...\" "
    wgetcmd += "--output-document  #{btfilename} "
    wgetcmd += " --load-cookies  #{bitmecookie} "
    wgetcmd += dlink
    
    
    system(wgetcmd) 
    
  
ie = Watir::Browser.new
ie.goto btfileverify
#File.delete(btfileverify) if File.exist?(btfileverify)

  if ie.text.include?("Not logged in!")
    puts "bitme said not logged in, exit program "
    exit
  end
  

return ie
end

def Bitme.saveSID(sid)
  softid=sid.to_s
  newMyID=Misc.getNewMyID()
  
ie=self.wgetOpenPage(sid)



#ie = Watir::Browser.new
#ie.goto dlink  
  if ie.text.include?("Error") and ie.text.include?("No torrent with ID")
    puts "the page does not hosted any torrent, expired?"
    return
  end


  if !ie.text.include?("No torrent with ID")




softname=ie.title.gsub(/^.*Details for torrent/,"").gsub(/"/,"").strip
softname=Iv.softnameProcess(softname)
softname=Misc.txt2Sql(softname)
#ryan todo handle softname here



 


 if Misc.hasSoftName(softname).to_s=="0"
   #puts "haha"+Misc.hasSoftName(softname).to_s
  maintable= ie.table(:index,18)

  
  
 h_rowhash = {}
 for i_rowcounter in 2..maintable.row_count
 txt= maintable.row(:index,i_rowcounter)[1].text
 txt=txt.gsub(/ /,"").downcase
 txt=txt.gsub(/\r|\n/,"").downcase.strip
 h_rowhash[txt] = i_rowcounter 
 end
 
category="null"
regDate="null"
sizeall="null"
url="null"
fileCount="null"
fileCount="null"
fileCount="null"

 
 
if h_rowhash.has_key?("type".downcase);  category= maintable.row(:index,h_rowhash["type".downcase])[0].text; end
if h_rowhash.has_key?("added".downcase); regDate= maintable.row(:index,h_rowhash["added".downcase])[0].text.split( )[0]; end
if h_rowhash.has_key?("size".downcase);  sizeall= maintable.row(:index,h_rowhash["size".downcase])[0].text; end
if h_rowhash.has_key?("url".downcase);  url= maintable.row(:index,h_rowhash["url".downcase])[0].text;url=url.downcase;url=url.gsub(/http:\/\//,"")  end
if h_rowhash.has_key?("numfiles".downcase);  fileCount= maintable.row(:index,h_rowhash["numfiles".downcase])[0].text.gsub(/\D/,""); end
if h_rowhash.has_key?("description".downcase);  descHtm= maintable.row(:index,h_rowhash["description".downcase])[0].html; end
if h_rowhash.has_key?("description".downcase);  desctxt= maintable.row(:index,h_rowhash["description".downcase])[0].text; end


descHtm=descHtm.gsub(/^<TD class=latest vAlign=top align=left>/,"")
descHtm=descHtm.gsub(/<\/TD>$/,"")

  sizeNumber=sizeall.split()[0]
  sizeUnion=sizeall.split()[1]
  


  
  puts "softid is: "+softid
  puts "softname is: "+softname
  puts "category is: "+category
  puts "regDate is: "+regDate
  puts "sizeNumber is: "+sizeNumber
  puts "sizeUnion is: "+sizeUnion
  puts "url is: "+url
  





#各个文件信息

if h_rowhash.has_key?("filelist[hidelist]".downcase)
filetable=ie.table(:index,20)
sqlfilearr=[]
#fileCount=(filetable.row_count.to_i-1).to_s

  for i in 2..filetable.row_count

filesizetext=filetable.row(:index,i)[0].text.gsub(/,/, ".").gsub(/ +/," ").strip

 eachFilename=Misc.txt2Sql(filetable.row(:index,i)[1].text)
 eachFilesizeV=Misc.txt2Sql(filesizetext.split()[0])
 eachFilesizeU=Misc.txt2Sql(filesizetext.split()[1].upcase)
 if eachFilesizeU.strip.upcase=="B"
   eachFilesizeU="Byte"
end #if eachFilesizeU.strip="B"

#puts eachFilename+eachFilesizeV+eachFilesizeU

 
 sqlF="INSERT INTO `files` ( `myID` , `filename` , `filesize` , `sizeunion` , `md5` ) VALUES ("
 sqlF=sqlF+ \
     newMyID +",'"  \
      + eachFilename+"','"  \
      + eachFilesizeV+"','"  \
      + eachFilesizeU+"','"  \
      + "NULL"+"'" \
      +"); "
 
 sqlfilearr << sqlF
end #for i in 2..filetable.row_count

end #if h_rowhash.has_key?("filelist[hidelist]".downcase)


#软件描述_text
#desctxt= maintable.row(:index,4)[0].text
desctxt= Misc.wordProcess(desctxt)
desctxt= Iv.descTextProcess(desctxt)

#软件描述_html 
#descHtm= maintable.row(:index,4)[0].html
descHtm=Misc.wordProcess(descHtm)
#descHtm=Iv.descHtmlProcess(descHtm) #bitme no need google translate,since google translate is not so stable.
descHtm=descHtm.gsub(/\/redir.php.url=/,"")

#图片
imgarr=[]
ie.images.each { |i| 
if !i.src.to_s.include?("bitme")
#puts i.src.to_s 
imgarr << i.src.to_s 
end
}


sqlD="INSERT INTO `description` ( `myID` , `html` , `txt` ) "
 sqlD=sqlD+"VALUES ("
 sqlD=sqlD + \
      newMyID +",'"  \
      + Misc.txt2Sql(descHtm)+"','"  \
      + Misc.txt2Sql(desctxt)+"'"  \
      +"); "
#puts sqlD   


sqlM="INSERT INTO `main` \
    ( `myID` , `site` , `category` , `softuid` , `softname` , `register` , `sizevalue` , `sizeunion` , `filecount` , `adddaytime` ) "
 sqlM=sqlM+"VALUES ("
 sqlM=sqlM + \
      newMyID +",'"  \
      + "bitme"+"','"  \
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
 puts "executed:  " +sqlM

Misc.insert2file(sqlfilearr)
Misc.insert2image(newMyID,imgarr)
Misc.googleSearchTitleImg(newMyID)
Misc.insert2featured(newMyID)

if Misc.hasmyIDDescription(newMyID).to_s=="0".to_s
Misc.dbprocess(sqlD)
else
  puts "id "+newMyID.to_s+"have already in table Description"
end #if !self.hasmyIDDescription(newMyID)

  
if h_rowhash.has_key?("url".downcase)
  if (Misc.dbshow("select count(*) from `url` where `myID`="+newMyID) == "0")
    Misc.dbprocess("insert into `url` (`myID`,`url`) values (\""+newMyID+"\",\""+Misc.txt2Sql(url)+"\")")
  end # if (Misc.dbshow("select count(*) from `url` where `myID`="+newMyID) == "0")
end  #if h_rowhash.has_key?("url".downcase)


 else # if Misc.hasSoftName(self.txt2Sql(softname)).to_s=="0"
 puts softid.to_s+" have exists"
 #puts Misc.hasID(softid.to_s)
 #puts Misc.hasSoftName(softname.to_s)

 end #  if Misc.hasSoftName(self.txt2Sql(softname)).to_s=="0"

      
#end #if self.hasID(sid.to_s).to_s=="0"
end #if !ie.txt.include?("No posts exist for this topic") and !ie.text.include?("Could not obtain user information")
ie.close

end  #def bitme.saveSID(sid)





def Bitme.saveTorrentAutoit(softid)
  softid=softid.to_s
  ie = Watir::Browser.new
  ie.goto "http://www.bitme.org/details.php?id="+softid
  if !ie.text.include?("Error") and !ie.text.include?("No torrent with ID")

     maintable= ie.table(:index,18)
     torlink=maintable.row(:index,1).link(:index,1)
     torSavePath="c:\\tmp\\"
     torSaveName="bitme#{softid}_"+Iv.cygwindlname(torlink.text.gsub(".torrent",""))+".torrent" 
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
  
end #def Bitme.saveTorrentAutoit(softid) 





 
 def Bitme.launchUtorrentDownload(torFile,utorrentlog,btsavedir)   
 tmpbat="c:\\tmp\\utorrent.bat" 
 
 cmd="\"c:\\Program Files\\uTorrent\\uTorrent.exe\"" 
 cmd=cmd+" /LOGFILE \"#{utorrentlog}\"  /BRINGTOFRONT" 
 cmd=cmd+" /DIRECTORY \"#{btsavedir}\" "   
 cmd=cmd+"\"#{torFile}\""


Misc.saveTxt2FileOverwrite(cmd,tmpbat)
system("start /min #{tmpbat}")
sleep 3
File.delete(tmpbat)
end # def Bitme.launchUtorrentDownload()



def Bitme.checkUtorrentJobStatus(utorrentJoblog,btsavedir)
  
  
File.open(utorrentJoblog).each_line do |line|
   line.chomp!
   status=line.split("TorStatus:")[1].split(",")[0]
   savedir=line.split("TorSaveDir:")[1].split(",")[0]
   tortitle=line.split("TorTitle:")[1].split(",")[0]
   time=line.split("]")[0]+"]"
   timenow=Misc.datenow2
   
   
    if ( line.include?("TorStatus:Seeding") or line.include?("TorStatus:Finished") ) and line.include?("TorSaveDir:#{btsavedir}")
     puts "\t#{timenow}, Seeding, "+savedir[0..200]+", \""+tortitle[0..300]+"\""
     return "Seeding"
   end
  
   

   if line.include?("TorStatus:Downloading") and line.include?("TorSaveDir:#{btsavedir}")
     puts "\t#{timenow}, Downloading, "+savedir[0..200]+", \""+tortitle[0..300]+"\""
     return "Downloading"

   end


end.close  #File.open(utorrentlog).each_line do |line|
    

end #def Bitme.checkUtorrentJobStatus(utorrentlog,btsavedir)






def Bitme.uTorrentDownloadAndMonitorTorrent(torFile,btsavedir)
  # this function designed to works for any torrent file for any sites.
  # 1.launch utorrent download torfile
  # 2.check download job peroidcally (60sec), quit until status change to 'seeding'
  
  utorrentlog="c:\\ruby_project\\log\\utorrent.log"
  utorrentJoblog="c:\\ruby_project\\log\\utorrent_job.log"
  File.delete(utorrentJoblog) if File.exist?(utorrentJoblog)
  self.launchUtorrentDownload(torFile,utorrentlog,btsavedir)
  self.waitUntilUtorrentJobToSeeding(utorrentJoblog,btsavedir)
  
end #def Bitme.uTorrentDownloadAndMonitorTorrent(torFile,btsavedir)




def Bitme.waitUntilUtorrentJobToSeeding(utorrentJoblog,btsavedir)
  btjobStatus=self.checkUtorrentJobStatus(utorrentJoblog,btsavedir)

  while btjobStatus != "Seeding"
    btjobStatus=self.checkUtorrentJobStatus(utorrentJoblog,btsavedir)
    sleep 6
  end
  
  if btjobStatus == "Seeding"
    puts "=========="
    timenow=Misc.datenow2
    puts "#{timenow}, BT download finished,#{btsavedir}\\"
    puts "=========="
    return "btDownloadFinished"
  end
  
end #def Bitme.waitUntilUtorrentJobToSeeding(utorrentlog,btsavedir)




def Bitme.isPageLivedinBitme(bitmeId)
  rtn=true
  ie=self.wgetOpenPage(bitmeId)
  if ie.text.include?("No torrent with ID")
    puts "bitme does Not host this torrent, http://www.bitme.org/details.php?id=#{bitmeId} "
    rtn=false
  end
 
  ie.close
  return rtn
end  #def Bitme.isPageLivedinBitme(bitmeId)



def Bitme.getPIDbyMyID(unidbmyid) 
  sql="SELECT `products_id` FROM `products` WHERE `myID`= #{unidbmyid}"
  rtn=Misc.dbshowCommon("zencart.bitme",selectsql)
  return rtn
end #def Bitme.getPIDbyMyID(unidbmyid)



def Bitme.isBitmeTorrentSaved(bitmeid)
  rtn=true
  arr=Dir.glob("c:/wamp/www/torrents/bitme/#{bitmeid}_*.torrent")
 # puts "arr is "
 # puts arr
 # exit
  if arr.empty?
    puts "the torrentfile not saved."
    rtn=false 
  end
  return rtn
end

def Bitme.getSavedBitmeTorrentFilename(bitmeid)
   if self.isBitmeTorrentSaved(bitmeid) == false
     puts "canNot get torrent filename, the torrent file for id #{bitmeid} not found"
     return false
   end
   
     rtn=Dir.glob("c:/wamp/www/torrents/bitme/#{bitmeid}_*.torrent").split("/")[-1]
     return rtn

end #def Bitme.getSavedBitmeTorrentFilename(bitmeid)

def Bitme.isBitmeTorrentSavedToDlpathmapTbl(bitmeid)
   myid=Misc.getMyidBySoftuid("bitme",bitmeid) 
   return Zencart.haszencartdlpathmap(myid)
end
   

end #end of the module