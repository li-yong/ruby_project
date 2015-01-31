### THIS FILE WAS REPLACED BY taobaoGeneral.rb ####

# -*- coding: utf-8 -*-
module Realdb
require "misc"
require "iv"
require "cmm"



def Realdb.getTitleImage(ie)
  if  ie.image(:id,"J_ImgBooth").exist?
    return  ie.image(:id,"J_ImgBooth").src
  else
    return nil
  end
  
end  #def Realdb.getTitleImage(ie)



def Realdb.parseItem(taobaopid)

  maxMyID=Misc.getMaxMyID()
  newMyID=maxMyID.to_i + 1
  newMyID=newMyID.to_s

link="http://item.taobao.com/item.htm?id="+taobaopid.to_s
ie= Watir::Browser.new
#wait 30 seconds for page load.
Cmm.launchIEwithTimeout(ie,link,30)  



puts "==== Start Processing taobaopid #{taobaopid} "
#中文名
productname="null"
if (ie.div(:id,"detail").div(:class, "detail-hd").h3(:index,1).exist?)
productname=ie.div(:id,"detail").div(:class, "detail-hd").h3(:index,1).text
#productname=Misc.googletranslatetoen(productname)
productname=Iv.softnameProcessWithGoogleTrans(productname)

productname=productname.gsub(/apple/i, "MAC")
productname=productname.gsub(/\?/,"")
end
puts "productName: "+productname
#exit


if productname=="null"
  puts "productname is null, not processing following"
  ie.close

elsif (Misc.hasSoftName(productname).to_s != "0")  
  puts "productname existed in unidb, not processing following"
  ie.close
else
  softcategory=Cmm2.publicgetcatID(productname)
  puts "puts to category #{softcategory}"




titleimage=self.getTitleImage(ie)

 

 



#描述 
desc=ie.div(:id, "J_DivItemDesc")

   imgarr=[]
   desc.images.each {|x| imgarr << x.src.to_s   } #描述中的图片
   
   #Misc.saveTxt2File(desc.html, "ori.del.htm")
   descEnHtml=Iv.descHtmlProcess(desc.html)
   #Misc.saveTxt2File(descEnHtml, "afterTrans.taobao.htm")
   descEnTx = Iv.descTextProcess(descEnHtml)
 

#descEnHtml="demo"
#descEnTx="demo"

 puts descEnHtml
 
   exit
   
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
      + "taobao"+"','"  \
      + Misc.txt2Sql(softcategory)+"','"  \
      + Misc.txt2Sql(taobaopid.to_s)+"','"  \
      + Misc.txt2Sql(productname)+"','"  \
      + Misc.txt2Sql(softreleasetime)+"','"  \
      + Misc.txt2Sql(totalsizeNumber)+"','"   \
      + Misc.txt2Sql(totalsizeUnion)+"','"  \
      + Misc.txt2Sql(filecount.to_s)+"','"   \
      + Misc.datenow()+"'" \
      +"); "






 if ((Misc.hasSoftName(productname).to_s=="0") and (productname != "null"))
   
   Misc.dbprocess(sqlM)
   puts "inserted to Main table"
   if !titleimage.nil?
      Misc.insertTitleImage(newMyID,titleimage.to_s)
      puts "inserted title image"
    else
      Misc.googleSearchTitleImg(newMyID)
   end
   
   

   
   #decide not input taobao description page images to db
   #Misc.insert2image(newMyID,imgarr) 

  if Misc.hasmyIDDescription(newMyID).to_s=="0".to_s
   Misc.dbprocess(sqlD)
    puts "inserted to description table"
   Misc.insert2featured(newMyID) 
   else
  puts "id "+newMyID.to_s+"have already in table Description"
  end #if !self.hasmyIDDescription(newMyID)
   
   
  else 
    puts softid.to_s+" have exists or productnameIsNull"
   
 end #  if ((Misc.hasSoftName(productname).to_s=="0") and (productname != "null"))
 
  
  
end  # if productname=="null"
 
 
 ie.close
  
end #def Realdb.parseItem(ie,link)
  




def Realdb.getthisPageItemsArray(ie,pageurl)
 ie.goto(pageurl)
 
 itemlis=[]
 rtnArray=[]
 itemlis=ie.ul(:class,"shop-list").lis
 itemlis.each{|li|
 rtnArray << li.link(:class,"permalink").href.split("=")[1]
 }
 ie.close
 return rtnArray
end #def Realdb.getthisPageItemsArray(pageurl)




def Realdb.handleOnePage(thisPageItemsArray,pageNumber)

thisPageItemsArray.each { |taobaopid| 
   if (Misc.hasID(taobaopid,"taobao").to_s=="0") 
     puts ""
     print "+++++ START, " 
     puts (thisPageItemsArray.index(taobaopid)+1).to_s + "/" + thisPageItemsArray.length.to_s + " items of this page is processing, page #{pageNumber}"
     Realdb.parseItem(taobaopid)
   else
       puts "ID "+taobaopid+" for taobao already existed in unidb"
   end     
     } #thisPageItemsArray.each { |taobaopid| 
end #def Realdb.handleOnePage(thisPageItemsArray)



  def Realdb.getMaxMyID(odbc)
    sql="SELECT MAX(myID) FROM `main` WHERE 1"
    a=Misc.dbshowCommon(odbc,sql)  
    a="0" if a.nil?
    a="0" if a==""
    return a
  end #def Realdb.getMaxPID(odbc)
  












end #module Realdb