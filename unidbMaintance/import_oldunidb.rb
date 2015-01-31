# -*- coding: utf-8 -*-



#$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"  
$LOAD_PATH << "c:/ruby_project/lib"  



require 'misc'
require 'DBI'



def importoldunidb(myidold)
odbc="unidb.old"
myidold=myidold.to_s
sqlmain="select * from `main` where `myID`=#{myidold}"
sqldlpathmap="select * from `dlpathmap` where `myID`=#{myidold} "
sqlimages="select * from `images` where `myID`=#{myidold} "

sqldescription="select * from `description` where `myID`=#{myidold}"
sqlfiles="select * from `files` where `myID`=#{myidold}"
sqlurl="select * from `url` where `myID`=#{myidold}"

 
 resultArrayMain= Misc.dbshowArrayCommon(odbc,sqlmain)
 resultArrayDlpathmap= Misc.dbshowArrayCommon(odbc,sqldlpathmap)
 resultArrayImages= Misc.dbshowMultiArrayCommon(odbc,sqlimages) 

 resultArrayDescription= Misc.dbshowArrayCommon(odbc,sqldescription)
 resultArrayFiles= Misc.dbshowMultiArrayCommon(odbc,sqlfiles)
 resultArrayUrl= Misc.dbshowArrayCommon(odbc,sqlurl)

 
 
newMyID=Misc.getNewMyID()

  










###### MAIN TABLE #######
myidold=resultArrayMain[0]
siteold=resultArrayMain[1]
categoryold=resultArrayMain[2]
softuidold=resultArrayMain[3]
softnameold=resultArrayMain[4]
registerold=resultArrayMain[5]
sizevalueold=resultArrayMain[6]
sizeunionold=resultArrayMain[7]
filecountold=resultArrayMain[8]
adddaytimeold=resultArrayMain[9]
 


####### dlpathmap.old table ########

protocolold=resultArrayDlpathmap[1]
serverold=resultArrayDlpathmap[2]
portold=resultArrayDlpathmap[3]
ppathold=resultArrayDlpathmap[4]
pathold=resultArrayDlpathmap[5]

if ppathold=="gweb"
  year=pathold.split("-")[0]
  month=pathold.split("-")[1]
  if month.length == 1
    month="0"+month
  end
  ppathold=year+month
end



########  images.old table ##########


  imgsrcarr=[]
  imgsqlarr=[]
  
  
  resultArrayImages.each {|oneimagerow|
  #p oneimagerow
  imagepathold=oneimagerow[1]
  imgLclPthold=oneimagerow[2]
  titleimageold=oneimagerow[3]
  hasSiteLogoold=oneimagerow[4]
  imgsizeinbyteold=oneimagerow[5]
  
  
  #if Misc.txt2Sql(imgLclPthold) == ""
  # comment if block for save time purpose when import from old, not open IE and download image
  #imgsrcarr << imagepathold
  
  #else
       sql="INSERT INTO `images` ( `myID` , `imagepath` , `imgLclPth`, `titleimage` , `HasSiteLogo` , `imgsizeinbyte` )"
                        sql=sql+"VALUES ("
                        sql=sql + \
                        Misc.txt2Sql(newMyID.to_s) +",'"  \
                        + Misc.txt2Sql(imagepathold.to_s)+"','"  \
                        + Misc.txt2Sql(imgLclPthold.to_s)+"','"  \
                        + Misc.txt2Sql(titleimageold.to_s)+"','"  \
                        + Misc.txt2Sql(hasSiteLogoold.to_s)+"','"  \
                        + Misc.txt2Sql(imgsizeinbyteold.to_s)+"');"  
                        
  imgsqlarr << sql

 #end  # if imgLclPthold.strip == ""
 
 
} #resultArrayImages.each {|oneimagerow| 


#Misc.insert2image(newMyID,imgsrcarr.uniq) if !imgsrcarr.empty?
imgsqlarr=imgsqlarr.uniq  #for same id, only need same pic once.




######### url.old ######
urlold=resultArrayUrl[1]
 


######### files.old  ####
filesqlarr=[]
resultArrayFiles=resultArrayFiles.uniq
resultArrayFiles.each {|filerecordsArray| 

  filenameold=filerecordsArray[1]
  filesizeold=filerecordsArray[2]
  sizeunionold=filerecordsArray[3]
  md5old=filerecordsArray[4]

 # Misc.insertOneFile(newMyID,filenameold,filesizeold,sizeunionold,md5old)
  
  
   sqlF="INSERT INTO `files` ( `myID` , `filename` , `filesize` , `sizeunion` , `md5` ) VALUES ("
 sqlF=sqlF+ \
     Misc.txt2Sql(newMyID) +",'"  \
      + Misc.txt2Sql(filenameold)+"','"  \
      + Misc.txt2Sql(filesizeold)+"','"  \
      + Misc.txt2Sql(sizeunionold)+"','"  \
      + Misc.txt2Sql(md5old)+"'" \
      +"); "
  
  filesqlarr << sqlF
  
  
} 



######### description.old ####
 htmlold=resultArrayDescription[1]
 txtold=resultArrayDescription[2] 




######### Insert to DB #####

result=Misc.insertMain(newMyID,siteold,categoryold,softuidold,softnameold,registerold,sizevalueold,sizeunionold,filecountold,adddaytimeold)
 if result == 1
   return 
 end
puts "\ninserted old myID #{myidold} as myID #{newMyID}" 
Misc.insertDlPathmap(newMyID,protocolold,serverold,portold,ppathold,pathold) ; puts "    inserted dlpathmap"
Misc.executeSqls(imgsqlarr.uniq) if !imgsqlarr.empty? ; puts "    inserted images"
Misc.insertUrl(newMyID,urlold); puts "    inserted url"
Misc.executeSqls(filesqlarr.uniq) if !filesqlarr.empty? ; puts "\n    inserted files"
Misc.insertDescription(newMyID,htmlold,txtold) ; puts "    inserted desc"

end #def importoldunidb(oldmyid)

oldsql="SELECT `myID` FROM `main`  where `myID` >= 26898  ORDER BY `myID` ASC " #LIMIT 30, 60
oldmyidarr= Misc.dbshowMultiArrayCommon("unidb.old",oldsql)
oldmyidarr.each{ |oldid|
importoldunidb(oldid[0])
}


#importoldunidb("24203")