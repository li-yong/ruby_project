module Misc
require 'DBI'



def Misc.datenow()
  
 year=DateTime.now.year.to_s
 mon=DateTime.now.month.to_s
 day=DateTime.now.day.to_s
 hour=DateTime.now.hour.to_s
 min=DateTime.now.min.to_s
 sec=DateTime.now.sec.to_s      
 #puts year+"-"+mon+"-"+day+" "+hour+":"+min+":"+sec
 return year+"-"+mon+"-"+day+" "+hour+":"+min+":"+sec
 end #def Misc.datenow()

def Misc.saveTxt2File(txt,filename)
  comments="-- "+self.datenow()
  myfile=File.new(filename,"a+")
  #myfile.puts(comments)
  myfile.puts(txt)
  myfile.close
end #def Misc.saveTxt2File(txt,file)


def Misc.dbprocess(sql)
  #sql=self.txt2Sql(sql.to_s)
  dbh = DBI.connect('DBI:ODBC:unidb','root','fav8ht39')
  #dbh = DBI.connect('DBI:ODBC:unidb','ryanTest2','AppleQ3Aj8X4dE')
  #dbh = DBI.connect('DBI:ODBC:unidb_testuse','root','fav8ht39')

  #puts sql
  
  file="c:\\tmp\\"+Misc.datenow().split(' ')[0]+".sql_unidb"
  sql=sql+";"
  
  dbh.do(sql)
  self.saveTxt2File(sql,file)
  print "."
  sleep 0.01
  dbh.disconnect if dbh
end




def Misc.dbprocessTEST(sql)
  dbh = DBI.connect('DBI:ODBC:unidb_testuse','root','fav8ht39')
  dbh.do(sql)
  dbh.disconnect if dbh
end



#back first record with selectsql result
def Misc.dbshow(selectsql)
  #selectsql=self.txt2Sql(selectsql.to_s)  
  resultarr=[]
  #puts selectsql
  dbh = DBI.connect('DBI:ODBC:unidb','root','fav8ht39')
  #dbh = DBI.connect('DBI:ODBC:unidb','ryanTest2','AppleQ3Aj8X4dE')
  #dbh = DBI.connect('DBI:ODBC:unidb_testuse','root','fav8ht39')
  sth = dbh.prepare(selectsql)
  sth.execute
 # sleep 2
   while row=sth.fetch do
        #p row
        resultarr << row
    end
   
  dbh.disconnect if dbh
  
  if resultarr.length > 0
  return resultarr[0][0].to_s
  #puts resultarr[0][0]
  else
  return ""
  end#  if resultarr.length > 0
end#def Misc.dbshow(selectsql)


#back one column  array with selectsql result
def Misc.dbshowArray(selectsql)
  

  
  
  #selectsql=self.txt2Sql(selectsql.to_s)  
  resultarr=[]
  #puts selectsql
  dbh = DBI.connect('DBI:ODBC:unidb','root','fav8ht39')
  sth = dbh.prepare(selectsql)
puts selectsql
sth.execute
   while row=sth.fetch do
        #p row[0]
        resultarr << row[0]
  end
    
   #puts sth
  dbh.disconnect if dbh
  
  if resultarr.length > 0
  return resultarr
  else
  return ""
  end#  if resultarr.length > 0
end#def Misc.dbshowArray(selectsql)




def Misc.dbshowMultiResults(selectsql)
  #selectsql=self.txt2Sql(selectsql.to_s)  
  #puts selectsql
  resultarr=[]
  dbh = DBI.connect('DBI:ODBC:unidb','root','fav8ht39')
  sth = dbh.prepare(selectsql)
  sth.execute
  resultarr=sth.fetch_all.join(",").split(",")
  dbh.disconnect if dbh
  return resultarr  # ["1", "2", "3", "4", "5", "6"]
end#def Misc.dbshowMultiResults(selectsql)




def Misc.dbshowWholeArray(selectsql)
  #selectsql=self.txt2Sql(selectsql.to_s)  
  #puts selectsql
  resultarr=[]
  dbh = DBI.connect('DBI:ODBC:unidb','root','fav8ht39')
  sth = dbh.prepare(selectsql)
  sth.execute
     while row=sth.fetch do
        #p row
        resultarr << row
       # p resultarr
  end

  dbh.disconnect if dbh
  return resultarr
  


end#def Misc.dbshowWholeArray(selectsql)




#back multi column  array with selectsql result
def Misc.getfiles(selectsql)
  #selectsql=self.txt2Sql(selectsql.to_s)  
  resultarr=[]
  #puts selectsql
  dbh = DBI.connect('DBI:ODBC:unidb','root','fav8ht39')
  sth = dbh.prepare(selectsql)
  sth.execute
   while row=sth.fetch do
        #p row
        #resultarr << row[0]+"<mysep,>"+row[1]+"<mysep,>"+row[2]
        judge = row[0].nil? or row[1].nil? or row[2].nil? 
        if !judge
        resultarr << [row[0],row[1],row[2]]
        #puts resultarr
        end
    end
    
 
  dbh.disconnect if dbh
  
  if resultarr.length > 0
  return resultarr
  else
  return ""
  end#  if resultarr.length > 0
end#def Misc.dbshowArrayMulti(selectsql)


#return 1 if give softid existed. (softid is the uid in each software site)
#return 0 if give softid not existed.
def Misc.hasID(id,site)
  site=site.to_s.strip
  id=self.txt2Sql(id.to_s) 
  sql="SELECT count( * ) \
      FROM `main` \
      WHERE `softuid` ="
  sql=sql+ id.to_s 
  sql=sql+" and `site`=\""+site+"\""

  #puts sql
  self.dbshow(sql)

end


#return 1 if give softid existed. (softid is the uid in each software site)
#return 0 if give softid not existed.
def Misc.hasFile(myid)
  id=self.txt2Sql(myid.to_s) 
  sql="SELECT count( * ) \
      FROM `files` \
      WHERE `myID` ="
  sql=sql+id.to_s
  #puts sql
  self.dbshow(sql)

end


#return0 if give myid existed in `description` table
def Misc.hasmyIDDescription(myid)
  myid=self.txt2Sql(myid.to_s) 
  sql="SELECT count( * ) \
      FROM `description` \
      WHERE `myID` ="
  sql=sql+myid.to_s
  
  self.dbshow(sql)
  #puts sql

  
end #def Misc.hasmyIDDescription(myid)

def Misc.hasSoftName(softname)
  softname=self.txt2Sql(softname.to_s)
  sql="SELECT count( * ) \
      FROM `main` \
      WHERE `softname` ='"
  sql=sql+softname.to_s
  sql=sql+"';"
  #puts sql
  self.dbshow(sql)

end #def Misc.hasSoftName(softname)





  
def Misc.hasdlpathmap(myid)
  id=self.txt2Sql(myid.to_s) 
  sql="SELECT count( * ) \
      FROM `dlpathmap` \
      WHERE `myID` ="
  sql=sql+id.to_s
  #puts sql
  self.dbshow(sql)
end #def Misc.hasdlpathmap(myid)


def Misc.getMyID(softname)
  softname=self.txt2Sql(softname.to_s)
  sql="select  `myID` \
      FROM `main` \
      WHERE `softname` =  "
 sql= sql+ "\""+ softname+"\""
 sql=sql+";"
  #puts sql
  self.dbshow(sql)

end #def Misc.getMyID(softname)


def Misc.deleteBySID(sid)
  
  
  sql0="DELETE FROM `main` WHERE `myID` = "
  sql0=sql0+sid
  sql0=sql0+" LIMIT 1"
  
  sql1="DELETE FROM `description` WHERE `myID` = "
  sql1=sql1+sid
  sql1=sql1+" LIMIT 1"
  
    
  sql2="DELETE FROM `images` WHERE `myID` = "
  sql2=sql2+sid
  
  
  sql3="DELETE FROM `files` WHERE `myID` = "
  sql3=sql3+sid


  


  self.dbprocess(sql0)
  self.dbprocess(sql1)
  self.dbprocess(sql2)
  self.dbprocess(sql3)
  
  
  
end #def Misc.deleteBySID(sid)


def Misc.delBySoftName(softname)
   sid=self.getMyID(softname)
   self.deleteBySID(sid)  
end #def Misc.delBySoftName(softname)
  



def Misc.hasInFileName(myid, insoftname) #check if individual file already insert into database
  insoftname=self.txt2Sql(insoftname.to_s)
  myid=self.txt2Sql(myid.to_s)
  
  sql="SELECT count( * ) \
      FROM `files` \
      WHERE `myID`=" + myid   + \
         "AND `filename` ='"
  sql=sql+insoftname.to_s
  sql=sql+"';"
  #puts sql
  
self.dbshow(sql)
  
end










def Misc.wordProcess(x)
  x1=self.removeCrackerOrg(x)
  x2=self.removeKW(x1)
  #donot include self.removeDot here
  #it suppose used for 9iv.ftp only
end

def Misc.txt2Sql(x)
      x=x.to_s
      x1=x.gsub(/'/,"''")  #' --> ''
   #   x2=x1.gsub(/"/,'')
   #   x3=x2.gsub(//,'')
  
end

def Misc.removeCrackerOrg(x)
x=x.to_s
if !x.nil?
i="-ACME|" \
    +"-AGAiN|" \
    +"-AiR|" \
    +"-DaD|" \
    +"-QUANTiZ|" \
    +".Cracked|" \
    +"-CODePD|" \
    +"-CFFPDA|" \
    +"-AiRISO|" \
    +"-ALiAS|" \
    +"-APXiSO|" \
    +"-ArCADE|" \
    +"-ARN|" \
    +"-Ayan13|" \
    +"-BACKLASH|" \
    +"-BB3D|" \
    +"-BBL|" \
    +"-BEAN|" \
    +"-BiNPDA|" \
    +"-BLiZZARD|" \
    +"-CAXiSO|" \
    +"-BRD|" \
    +"-BReWErS|" \
    +"-BSOUNDZ|" \
    +"-CAUiSO|" \
    +"-CFE|" \
    +"-CHiCNCREAM|" \
    +"-CoL|" \
    +"-CORE|" \
    +"-CRD|" \
    +"-CROSSFiRE|" \
    +"-CYGiSO|" \
    +"-CzW|" \
    +"-DAJEWS|" \
    +"-DDU|" \
    +"-DELiGHT|" \
    +"-DIGERATI|" \
    +"-DJiNN|" \
    +"-DOA|" \
    +"-DRL|" \
    +"-DVD9|" \
    +"-DVT|" \
    +"-DVTiSO|" \
    +"-DYNAMiCS|" \
    +"-DYNAMiCS|" \
    +"-EDGE|" \
    +"-ELPUTOGRANDE|" \
    +"-EMBRACE|" \
    +"-EMBRACE|" \
    +"-ENGiNE|" \
    +"-EQUiNOX|" \
    +"-ErESPDA|" \
    +"-ESET|" \
    +"-F4CG|" \
    +"-FALLEN|" \
    +"-FAS|" \
    +"-FCNiSO|" \
    +"-FEGPDA|" \
    +"-FOSI|" \
    +"-FtpDown|" \
    +"-G1R0cKz|" \
    +"-GETLiB|" \
    +"-GFX|" \
    +"-GFXnews|" \
    +"-GiZPDA|" \
    +"-GRB|" \
    +"-HACKERSVIEW|" \
    +"-Head of an Arab|" \
    +"-HEiRLOOM|" \
    +"-HELL|" \
    +"-HERiTAGE|" \
    +"-HMX0101|" \
    +"-HOTiSO|" \
    +"-HS|" \
    +"-HSpda|" \
    +"-iMST|" \
    +"-iND|" \
    +"-iNK|" \
    +"-iPA|" \
    +"-ISO|" \
    +"-JANOSiK|" \
    +"-JGTiSO|" \
    +"-JGTiSO 2009 2|" \
    +"-JUSTiSO|" \
    +"-KiMERA|" \
    +"-L3F0U|" \
    +"-LAME|" \
    +"-LAXiTY|" \
    +"-LiGHTHELL|" \
    +"-LMi|" \
    +"-LND|" \
    +"-Lz0|" \
    +"-MAGNiTUDE|" \
    +"-MAZE|" \
    +"-MiSSiON|" \
    +"-MP3|" \
    +"-MSGPDA|" \
    +"-NeoX|" \
    +"-NGEN|" \
    +"-nIV|" \
    +"-NoPE|" \
    +"-NULL|" \
    +"-oDDiTy|" \
    +"-OUTLAWS|" \
    +"-PARADOX|" \
    +"-PGN|" \
    +"-PH|" \
    +"-PlanB|" \
    +"-QUASAR|" \
    +"-RC4Y|" \
    +"-RECOiL|" \
    +"-RECOiL|" \
    +"-RENOiSE|" \
    +"-REUNION|" \
    +"-rG|" \
    +"-rGPDA|" \
    +"-RiFT|" \
    +"-RiSE Oracle|" \
    +"-RiTUEL|" \
    +"-ROGU|" \
    +"-ROGUE|" \
    +"-SaG|" \
    +"-SCENE|" \
    +"-SFNightmare|" \
    +"-SHOCK|" \
    +"-SHooTERS|" \
    +"-SiMPLiFY|" \
    +"-SiNiSTER|" \
    +"-SL|" \
    +"-SoS|" \
    +"-SoSISO|" \
    +"-SQUARE|" \
    +"-TBE|" \
    +"-TDA|" \
    +"-TE|" \
    +"-TFT|" \
    +"-TSG|" \
    +"-TYPO|" \
    +"-uIV|" \
    +"-UNION|" \
    +"-UNiQUE|" \
    +"-Unleashed|" \
    +"-VACE|" \
    +"-ViH|" \
    +"-ViP|" \
    +"-ViRiLiTY|" \
    +"-ViRiLiTY|" \
    +"-WiNK|" \
    +"-WoG|" \
    +"-XFORCE|" \
    +"-XiSO|" \
    +"-XiSO ERP|" \
    +"-XXII|" \
    +"-YPOGEiOS|" \
    +"-YYePGiSO|" \
    +"-ZuM|" \
    +"-ZWT|" \
    +"-ZWTiSO|" \
    +"-FoRTuNe|" \
    +"-ABSOKT|" \
    +"-SUNiSO|" \
    +".DVDR-|" \
    +"-TACTiLE|" \
    +"-BNT|" \
    +"-AMPLiFYiSO|" \
    +"-PANTHEON|" \
    +"-iPWNPDA|" \
    +"-ZZGiSO|"  \
    +"-NiGHTNiNG|" \
    +"-EAT|" \
    +"-AG|"    

  x.gsub(/#{i}/i,"")
  end #if !x.nil?
  end


def Misc.removeDot(x)
  x=x.to_s
  if !x.nil?
     # i="([a-zA-Z])\.([a-zA-Z)] "
     #x.gsub(/#{i}/,'\1 \2')
      x1=x.gsub(/([a-zA-Z])\.([a-zA-Z])/,'\1 \2')
      x2=x1.gsub(/([0-9])\.([a-zA-Z])/,'\1 \2')
      x3=x2.gsub(/([a-zA-Z])\.([0-9])/,'\1 \2')
 end #if !x.nil?
  end


def Misc.removeKW(x)
  x=x.to_s
  if !x.nil?
   i="crack|"\
        +"torrent|" \
        +"gfxnews|" \
        +"mininova|" \
        +"9down|" \
        +"hxsd|" \
        +"thepiratebay|" \
        +"rarbg|"  \
        +"9iv|"
        #+"mininova|" \
        #+"mininova|" \
        #+"mininova|" \        

        
   x.gsub(/#{i}/i,"")   
end #if !x.nil?   
        
end









def Misc.putSID(ie)  
  maintable=ie.table(:class,"borderbottom")
  
  arrSID = [ ]
  maintable.each { |x|
    if x.column_count == 15
      softid = x[4].html.split("?t=")[1].to_s.split("\"")[0].to_s
      if softid.to_i > 0 
           if self.hasID(softid.to_s).to_s=="0"
              arrSID << softid.to_s
              puts softid+" push to array"
           else
              print self.hasID(softid.to_s)
              puts softid+" existed, skip." 
           end
            
       end   
      #system(ru3_saveEachSoftPage.rb ie softid) 
    end 
  }
  
  arrSID.each{|softid| self.saveSID(softid) }

end


def Misc.getMaxMyID()
  sql="SELECT MAX(myID) FROM main WHERE 1"
  a=self.dbshow(sql)  
end





def Misc.savehtml2file(file,ie)
  myfile=File.new(file,"w+")
  myfile.puts(ie.html)
  myfile.close
end

# Most important function,
# Save page to DB
def Misc.saveSID(sid)
  sid=sid.to_s
  maxMyID=self.getMaxMyID()
  newMyID=maxMyID.to_i + 1
  newMyID=newMyID.to_s
  
  ie = Watir::IE.new
  ie.goto "http://forum.gfxnews.ru/viewtopic.php?t="+sid.to_s.chomp
  fullHtmlfile="c:\\tmp\\torrents\\softpage\\"+sid.to_s.chomp+".full.htm"
  descHtmfile="c:\\tmp\\torrents\\softpage\\"+sid.to_s.chomp+".desc.htm"
  descTxtfile="c:\\tmp\\torrents\\softpage\\"+sid.to_s.chomp+".desc.txt"
  allSoftIdFile="C:\\tmp\\torrents\\all.txt"
  csvfile="C:\\tmp\\torrents\\all.csv"
  
if !ie.text.include?("No posts exist for this topic") and !ie.text.include?("Could not obtain user information")


 #��������ҳ�浽�ļ� 
  fullHtml=File.new(fullHtmlfile.to_s,"w+")
  fullHtml.puts(ie.html)
  fullHtml.close
  

  
#�������,����,���,ע��ʱ��,�ļ���С,�ɷ�����,
  softid=sid.to_s
  softname=ie.table(:index,2)[1][1].div(:index,2).text
  softname=self.wordProcess(softname)

 if  self.hasSoftName(self.txt2Sql(softname)).to_s=="0"#sid is same as softid
   
  category= ie.table(:index,2)[1][1].div(:index,1).text.split("\>")[1]  
  maintable=ie.div(:class,"post").table(:class, "btTbl")
  regDate=maintable.row(:index,3).text.split( )[1]  
  sizeNumber=maintable.row(:index,5).text.split( )[1]  
  sizeUnion=maintable.row(:index,5).text.split( )[2]  
  canDownload=maintable.row(:index,6).text.split()[2]  
  


  
  puts "softid is: "+softid
  puts "softname is: "+softname
  puts "category is: "+category
  puts "regDate is: "+regDate
  puts "sizeNumber is: "+sizeNumber
  puts "sizeUnion is: "+sizeUnion
  puts "canDownload is: "+canDownload
 


#�����ļ���Ϣ
fileinfotable=maintable.row(:id,"filesinfo").table(:class,"btTbl")
fileCount=fileinfotable.row_count - 1
sqlfilearr=[]
for i in 2..fileinfotable.row_count
 #puts "inFileName is:"+fileinfotable.row(:index,i)[1].text
 
 filesizetext=fileinfotable.row(:index,i)[2].text.sub(/,/, ".").sub(/ +/," ")
 
 
 eachFilename=self.txt2Sql(fileinfotable.row(:index,i)[1].text)
 eachFilesizeV=self.txt2Sql(filesizetext.split()[0])
 eachFilesizeU=self.txt2Sql(filesizetext.split()[1].upcase)
 if eachFilesizeU.strip.upcase=="B"
   eachFilesizeU="Byte"
end #if eachFilesizeU.strip="B"

 #puts "inFileSizeNum is:"+ filesizetext.split()[0]
 #puts "inFileSizeUnit is:"+filesizetext.split()[1]
#if self.hasInFileName(newMyID,fileinfotable.row(:index,i)[1].text)=="0"
 
 sqlF="INSERT INTO `files` ( `myID` , `filename` , `filesize` , `sizeunion` , `md5` ) VALUES ("
 sqlF=sqlF+ \
     newMyID +",'"  \
      + eachFilename+"','"  \
      + eachFilesizeV+"','"  \
      + eachFilesizeU+"','"  \
      + "NULL"+"'" \
      +"); "
 
 sqlfilearr << sqlF
#end #if self.hasInFileName(myID,filename).to_s=="0"
     
end #for i in 2..fileinfotable.row_count


#��������_text
  destable=ie.div(:class,"post")
  tableDescText=destable.text.to_s
  
  if tableDescText.include?("Description")  
    start=tableDescText =~ /Description/
  else 
    start=0
  end
  
  start=start+ "Description".length
  start=start+1
  #sflag=softname+".torrent" #some page not using "softname.torrent" pattern
  sflag=".torrent"
  send=tableDescText =~ /#{sflag}/
  send=send.to_i - start

  desctxt= tableDescText[start,send]
  desctxt= self.wordProcess(desctxt)
  #puts "desctxt is: "+desctxt
  

  
  
  
#��������_html 
 tableDescHtml=destable.html.to_s  
  if tableDescText.include?("Description")  
    hstart= tableDescHtml=~ /Description/
    hstart=hstart+"Description</SPAN>:".length
  else 
    hstart=0
  end 
  

  hend= tableDescHtml=~ /js\/ajax.js/
  hend=hend-hstart
  hend=hend-15    
  descHtm=tableDescHtml[hstart,hend]
  descHtm=self.wordProcess(descHtm)
  #puts "descHtm is: "+descHtm

  
#ͼƬ
imgarr=[]
ie.images.each { |i| 
if !i.src.to_s.include?("gfxnews")
#puts i.src.to_s 
imgarr << i.src.to_s 
end
}
  
  
#�����ļ�
  fdescHtm=File.new(descHtmfile,"a")
  fdescHtm.puts(descHtm)
  fdescHtm.close
  
  fdescTxt=File.new(descTxtfile,"a")
  fdescTxt.puts(desctxt)
  fdescTxt.close

  #csv=File.new(csvfile,"a")
  #csv.puts(softid+","+softname+","+category+","+regDate+","+sizeNumber+","+sizeUnion+","+canDownload+","+fileCount)
  #csv.close
  
  



sqlD="INSERT INTO `description` ( `myID` , `html` , `txt` ) "
 sqlD=sqlD+"VALUES ("
 sqlD=sqlD + \
      newMyID +",'"  \
      + self.txt2Sql(descHtm)+"','"  \
      + self.txt2Sql(desctxt)+"'"  \
      +"); "
#puts sqlD   






sqlM="INSERT INTO `main` \
    ( `myID` , `site` , `category` , `softuid` , `softname` , `register` , `sizevalue` , `sizeunion` , `filecount` , `adddaytime` ) "
 sqlM=sqlM+"VALUES ("
 sqlM=sqlM + \
      newMyID +",'"  \
      + "gfxnews"+"','"  \
      + self.txt2Sql(category)+"','"  \
      + self.txt2Sql(softid.to_s)+"','"  \
      + self.txt2Sql(softname)+"','"  \
      + self.txt2Sql(regDate)+"','"  \
      + self.txt2Sql(sizeNumber)+"','"   \
      + self.txt2Sql(sizeUnion)+"','"  \
      + self.txt2Sql(fileCount.to_s)+"','"   \
      + self.datenow()+"'" \
      +"); "
      
  

 if  self.hasSoftName(softname.to_s).to_s=="0".to_s
 self.dbprocess(sqlM) 
 puts "executed:  " +sqlM

self.insert2file(sqlfilearr)
self.insert2image(newMyID,imgarr)

if self.hasmyIDDescription(newMyID).to_s=="0".to_s
self.dbprocess(sqlD)
end #if !self.hasmyIDDescription(newMyID)



 else # if self.hasID(softid.to_s).to_s=="0"
 puts softid.to_s+" have exists"
 puts self.hasID(softid.to_s)
puts self.hasSoftName(softname.to_s)

 end # if self.hasID(softid.to_s).to_s=="0"


      
end #if self.hasID(sid.to_s).to_s=="0"
end #if !ie.txt.include?("No posts exist for this topic") and !ie.text.include?("Could not obtain user information")
ie.close
end  #def Misc.saveSID(sid)


def Misc.insert2file(sqlfilearr)
 if ! sqlfilearr.nil?
   if !sqlfilearr.empty? 
sqlfilearr.each{|sql| 
 self.dbprocess(sql)         
}
end #if !sqlfilearr.empty? 
end # if ! sqlfilearr.nil?
  
end #def Misc.insert2file(sqlfilearr)



def Misc.insert2image(newMyID,imgarr)
if !imgarr.empty?
imgarr.each{|i| 
sql="INSERT INTO `images` ( `myID` , `imagepath` , `titleimage` , `HasSiteLogo` , `imgsizeinbyte` )"
 sql=sql+"VALUES ("
 sql=sql + \
       newMyID +",'"  \
       + self.txt2Sql(i.to_s)+"','"  \
       +"0','0','0');"

 self.dbprocess(sql)               
}
end #if !sqlfilearr.empty? 
  
end #def Misc.insert2image(sqlfilearr)




def Misc.readytobeRegularExpress(str)  
  rtrn=str.to_s
  if !rtrn.nil?
  rtrn=rtrn.gsub(/\?/,"")
  rtrn=rtrn.gsub(/\+/,"")
  rtrn=rtrn.gsub(/\-/,"")
  rtrn=rtrn.gsub(/\*/,"")
  rtrn=rtrn.gsub(/\\/,"")
  else
    rtrn=""
  end   #  if !rtrn.nil?
  
  return rtrn
end #def Misc.readytobeRegularExpress(str)



def Misc.splitSizeUnion(str)
  
x=str
x=Iv.dbsc2onespace(x)
x=Iv.descTextProcess(x)
x=Iv.removespace(x)

x=x.upcase
if x.include?("MB")
  size=x.split("MB")[0]
  union="MB"
 elsif  x.include?("GB")
  size=x.split("GB")[0]
  union="GB"
 elsif  x.include?("KB")
  size=x.split("KB")[0]
  union="KB"
  elsif  x.include?("BYTE")
  size=x.split("KB")[0]
  union="Byte"
  else
  size="unknow"
  union="unknow"
end #if x.include?("MB")
  

return [size,union]  
  
end #def Misc.splitSizeUnion(str)


end #end of whole module

 
