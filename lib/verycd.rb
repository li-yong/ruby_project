# -*- coding: utf-8 -*-
module Verycd
require "misc"
require "iv"
require "cmm"

def Verycd.returnSoftRootPages(ie,verycdCatLink)

ie.goto verycdCatLink.to_s

soft100PageLegth=ie.div(:id,"content").links.length
soft100PageLegth=soft100PageLegth-3

soft100HrefArray=[]
soft100index= soft100PageLegth+3
soft100PageLegth.times do
  soft100href=ie.div(:id,"content").link(:index,soft100index).href
 # puts soft100href
  soft100HrefArray<<soft100href
  soft100index=soft100index-1

end #soft100PageLegth.times do
return soft100HrefArray
end #def Verycd.returnSoftRootPages(ie,verycdCatLink)



def Verycd.categorymap(str)
if (str.nil?)
str=""
end #def Verycd.categorymap(str)

#back Category as input cateogry link
softcategory=str.to_s
if (softcategory.include?("os")) #操作系统
    softcategory="OS"
elsif (softcategory.include?("application"))#应用软件
    softcategory="App"
elsif (softcategory.include?("net"))#网络软件
    softcategory="Internet"
elsif (softcategory.include?("sys")) #系统工具
    softcategory="Utility"
elsif (softcategory.include?("multimedia"))#多媒体类
    softcategory="MutliMedia"
elsif (softcategory.include?("ind"))#行业软件
    softcategory="Productivity"
elsif (softcategory.include?("dev"))#编程开发
    softcategory="Program"
elsif (softcategory.include?("sec"))#安全相关
    softcategory="Security"
else
    softcategory="App"
end #softcategory=str.to_s


=begin
softcategory=str.to_s
if (softcategory.include?("\262\331\327\367\317\265\315\263")) #操作系统
    softcategory="OS"
elsif (softcategory.include?("\323\246\323\303"))#应用软件
    softcategory="App"
elsif (softcategory.include?("\315\370\302\347"))#网络软件
    softcategory="Internet"
elsif (softcategory.include?("\317\265\315\263\271\244\276\337")) #系统工具
    softcategory="Utility"
elsif (softcategory.include?("\266\340\303\275\314\345\300\340"))#多媒体类
    softcategory="MutliMedia"
elsif (softcategory.include?("\320\320\322\265"))#行业软件
    softcategory="Productivity"
elsif (softcategory.include?("\261\340\263\314\277\252\267\242"))#编程开发
    softcategory="Program"
elsif (softcategory.include?("\260\262\310\253\317\340\271\330"))#安全相关
    softcategory="Security"
else
    softcategory="null"
end #softcategory=str.to_s
=end
  
return softcategory


end   #def Verycd.categorymap(str)




def Verycd.returnSids(ie,link)
  

ie.goto link.to_s

verycdIdArray=[]
linklength=ie.div(:id,"resList").links.length
linkindex=1
linklength.times do
 verycdId=ie.div(:id,"resList").link(:index,linkindex).href.split("/")[4]
 #puts verycdId
 verycdIdArray<<verycdId  #verycdIdArray hold all id in current page
 linkindex=linkindex+1
  
end #linklength.times do

# 得到每页具体的软件ID end
 return verycdIdArray
end #def Verycd.returnSids(ie,link)




def Verycd.parseItem(ie,softid)

  maxMyID=Misc.getMaxMyID()
  newMyID=maxMyID.to_i + 1
  newMyID=newMyID.to_s

link="http://www.verycd.com/topics/"+softid.to_s

#wait 30 seconds for page load.
Cmm.launchIEwithTimeout(ie,link,30)  

#ie.goto(link)

if !ie.div(:class,"emulemain").exist?
  puts "Div emulemain not exist, return"
  return
end



#softCN Name
softcnname="null"
if (ie.div(:id,"iptcomCname").exist?)
softcnname=ie.div(:id,"iptcomCname").html.split("SPAN>")[-1].split("<\/DIV")[0]
end
puts "cnname: "+softcnname

#softVersion
if (ie.div(:id,"iptcomVersion").exist?)
softversion=ie.div(:id,"iptcomVersion").html.split("SPAN>")[-1].split("<\/DIV")[0] 
softversion="" if softversion.nil?
end
puts "Version: #{softversion}"

#softEN  Name
softenname="null"
if (ie.div(:id,"iptcomEname").exist?)
softenname=ie.div(:id,"iptcomEname").html.split("SPAN>")[-1].split("<\/DIV")[0] 
puts "Enname: #{softenname}"



splitMarker="_RYANSPLITMARKER_"
st="#{splitMarker}#{softenname} #{splitMarker}#{softversion} #{splitMarker}(#{softcnname})"
if Iv.hasDBCS(st)==true
  softName=Iv.descHtmlProcess(st)
end

if softName.nil?
  puts "softName is nil, not processing following"
  ie.close
  return
end





softName=softName.gsub("#{splitMarker}","")
softenname=softName

=begin
if !softnamenote.nil? and softnamenote.length > 6  
   softenname=softenname+" "+ softversion+ " ("+softnamenote+")"
   softenname=softenname.strip
 else
   softenname=softenname+" "+ softversion
   softenname=softenname.strip
end #if !softnamenote.nil? and softnamenote.length > 6 
=end 
end #if (ie.div(:id,"iptcomEname").exist?)
puts "overAllName "+softenname

if softenname=="null"
  puts "softenname is null, not processing following"
  ie.close
  return
elsif (Misc.hasSoftName(softenname).to_s != "0")  
  puts "softenname existed in unidb, not processing following"
  ie.close
  return
else
  
#format
=begin
softformat="null"
if (ie.div(:id,"iptcomFiletype").exist?)
softformat=ie.div(:id,"iptcomFiletype").html.split("\/SPAN>")[-1].split("</DIV")[0] 
softformat=Iv.descHtmlProcess(softformat)

  #\321\271\313\365\260\374 压缩包
end
puts "softformat: "+softformat
=end


#发行时间 verycd's reg date is too flex to insert to db
#if (ie.div(:id,"iptcomTime").exist?)
#softreleasetime=ie.div(:id,"iptcomTime").html.split("\/SPAN>")[-1].split("</DIV")[0] 
##\304\352 年
#end
softreleasetime="0000-00-00"  #'null'  is not supported to mysql5 srv
#puts "softreleasetime: "+softreleasetime

=begin 
#制作发行
softproducer="null"
if (ie.div(:id,"iptcomCompany").exist?)
softproducer=ie.div(:id,"iptcomCompany").span(:index,2).text 
softproducer=Iv.descHtmlProcess(softproducer)
end
puts "softproducer: "+softproducer 
=end




#category
catLink = ie.h2(:id,"whereru").link(:index,3).href # "http://www.verycd.com/sto/software/application/"
scat=catLink.split("/")[-1] 
softcategory=self.categorymap(scat)
    
puts " softcategory: " +softcategory  
   
#各个文件名称， 大小
filecount=0
sqlfilearr=[]




ie.div(:class,"emulemain").rows.each { |x| 

if (x.html.include?("TD class=post2") or  x.html.include?("TD class=post") \
    and !x.html.include?("class=\"emulesize") \
    and !x.html.include?("class=\"needemule") \
    and !x.html.include?("class=\"button downall") \
   )
 
 if x.cell(:index,1).html.nil? 
   puts "this row is not available, ignore this row"
   next 
 elsif x.cell(:index,1).html.split("value=ed2k:")[1].nil?
   puts "this row is not available, ignore this row"
   next   
 end
 
 emuleUrl=x.cell(:index,1).html.split("value=ed2k:")[1].split("/ name=")[0]
 emuleUrl="ed2k:"+emuleUrl+"/"
 emuleUrl=Misc.txt2Sql(emuleUrl)
 
 filecount=filecount+1

 filename=Iv.descTextProcess(x.cell(:index,1).text.gsub(/ \317\352\307\351/,""))
 filename=filename.gsub(/\[.*\]./,"")
 filename=Iv.removeDBCS(filename)
 filename=filename.gsub(/ /,".")
 filename=filename.gsub(".details","")
 filename=filename.gsub(/^\.+/,"")
 filename=filename.gsub(/.$/,"")
 sizeNumber=Misc.splitSizeUnion(x.cell(:index,2).text)[0]
 sizeUnion=Misc.splitSizeUnion(x.cell(:index,2).text)[1] 
 
 print "  filename: "+filename
 print "  sizeNumber:"+sizeNumber
 puts "  sizeUnion:"+sizeUnion
 
 
 sqlF="INSERT INTO `files` ( `myID` , `filename` , `filesize` , `sizeunion` , `md5`, `url` ) VALUES ("
 sqlF=sqlF+ \
     newMyID +",'"  \
      + Misc.txt2Sql(filename)+"','"  \
      + sizeNumber+"','"  \
      + sizeUnion+"','"  \
      + "NULL"+"','" \
      + emuleUrl + "'" \
      +"); "
 sqlfilearr << sqlF    
 
  
end #if (x.html.include?("TD class=post2") 

}  #ie.div(:class,"emulemain").rows.each
puts "filecount: "+filecount.to_s


#总大小
lastrow=ie.div(:class,"emulemain").rows.length
lastcell=ie.div(:class,"emulemain").row(:index,lastrow).cells.length
totalsize=ie.div(:class,"emulemain").row(:index,lastrow).cell(:index,lastcell).text
totalsizeNumber=Misc.splitSizeUnion(totalsize)[0]
totalsizeUnion=Misc.splitSizeUnion(totalsize)[1]
puts "totalsizeNumber:" + totalsizeNumber 
puts "totalsizeUnion: "+totalsizeUnion





#描述 
desc=ie.div(:id,"iptcomContents")
   imgarr=[]
   desc.images.each {|x| imgarr << x.src.to_s   } #描述中的图片
   
   descEnTx= Iv.descTextProcess(Iv.dbsc2onespace(desc.text))  
   descEnHtml=Iv.descHtmlProcess(desc.html) 
 
   #puts descEnHtml
   
  descCnTx= desc.text  
  descCnHtml=desc.html 
  

sqlD="INSERT INTO `description` ( `myID` , `html` , `txt`) "
 sqlD=sqlD+"VALUES ("
 sqlD=sqlD + \
      newMyID +",'"  \
      + Misc.txt2Sql(descEnHtml)+"','"  \
      + Misc.txt2Sql(descEnTx)+"'"  \
      +"); "
      

  
  


sqlM="INSERT INTO `main` \
    ( `myID` , `site` , `category` , `softuid` , `softname` , `register` , `sizevalue` , `sizeunion` , `filecount` , `adddaytime` ) "
 sqlM=sqlM+"VALUES ("
 sqlM=sqlM + \
      newMyID +",'"  \
      + "verycd"+"','"  \
      + Misc.txt2Sql(softcategory)+"','"  \
      + Misc.txt2Sql(softid.to_s)+"','"  \
      + Misc.txt2Sql(softenname)+"','"  \
      + Misc.txt2Sql(softreleasetime)+"','"  \
      + Misc.txt2Sql(totalsizeNumber)+"','"   \
      + Misc.txt2Sql(totalsizeUnion)+"','"  \
      + Misc.txt2Sql(filecount.to_s)+"','"   \
      + Misc.datenow()+"'" \
      +"); "






 if ((Misc.hasSoftName(softenname).to_s=="0") and (softenname != "null"))
   
   Misc.dbprocess(sqlM)
   
   Misc.insert2file(sqlfilearr)
   
 
   
   Misc.insert2image(newMyID,imgarr)
   Misc.googleSearchTitleImg(newMyID)
   Misc.insert2featured(newMyID)
   

  if Misc.hasmyIDDescription(newMyID).to_s=="0".to_s
   Misc.dbprocess(sqlD)
    
   else
  puts "id "+newMyID.to_s+"have already in table Description"
  end #if !self.hasmyIDDescription(newMyID)
   
   
  else 
    puts softid.to_s+" have exists or softENnameIsNull"
   
 end #  if ((Misc.hasSoftName(softenname).to_s=="0") and (softenname != "null"))
 
  
  
end  # if softenname=="null"
 
  
end #def Verycd.parseItem(ie,link)
  






end #module Verycd