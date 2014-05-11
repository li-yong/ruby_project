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


def Bitme.saveSID(sid)
  softid=sid.to_s
  maxMyID=Misc.getMaxMyID()
  maxMyID=Misc.getMaxMyID()
  newMyID=maxMyID.to_i + 1
  newMyID=newMyID.to_s
  ie = Watir::IE.new
  ie.goto "http://www.bitme.org/details.php?id="+sid.to_s.chomp+"&filelist=1#filelist"
  
  if !ie.text.include?("Error") and !ie.text.include?("No torrent with ID")




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
descHtm=Iv.descHtmlProcess(descHtm)
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


end #end of the module