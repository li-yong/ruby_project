module Iv
require "misc"


def Iv.removeDBCS(s)
  if s.nil? 
  s=""
  end #if s.nil?   
  return s.gsub(/[^[:alnum:][:punct:] ]/,"")
end #def Iv.removeDBCS(s)


def Iv.dbsc2onespace(s)
  if s.nil? 
  s=""
  end #if s.nil?   
  s= s.gsub(/[^[:alnum:][:punct:] ]/," ")
  s= s.gsub(/ +/," ")
end #def Iv.dbsc2space(s)


def Iv.softnameProcess(s)
  if s.nil? 
  s=""
  end #if s.nil?   
  s=s.gsub(/\(.*\)/,"")
  s=s.gsub(/\[.*\]/,"")
  s=s.gsub(/\{.*\}/,"")
  s=s.gsub(/\(.*\]/,"")
  s=s.gsub(/\[.*\)/,"")
  s=s.gsub(/（.*）/,"")
  s=self.removeDBCS(s)
  
  #s=s.gsub(/（.*)/,"")
 # s=s.gsub(/(.*）/,"")
 
 
  
  return self.removeDBCS(s)
end #def Iv.softnameProcess(s)


def Iv.descTextProcess(s)
  if s.nil? 
  s=""
  end #if s.nil?   
  s=self.dbsc2onespace(s)
  s= self.removeContinuesChat(s)
  s= s.gsub(/\)/,"")
  s= s.gsub(/\(/,"")
  s= s.gsub(/\]/,"")
  s= s.gsub(/\[/,"")
  s= s.gsub(/\.\.+/,"")
  s= s.gsub(/"/,"")
  s= s.gsub(/\( *\)/,"")

    s=s.gsub(/\''/,"''")
  s=s.gsub(/\'/,"'")
  s=s.gsub(/\?/,".")


  s=s.gsub(/\\'/,"'") 
  s=s.gsub(/\\/,"") 

  
  #s= s.gsub(/ */," ")  not work
  s= s.strip
   
 end #def Iv.descTextProcess(s)
 
 
 
 def Iv.descHtmlProcess(s)
  if s.nil? 
  s=""
  end #if s.nil? 
  s=self.dbsc2onespace(s)
  s=self.remove9ivImageAndLinkInHtml(s)
  s=self.removeContinuesChat(s)
  s= s.gsub(/\( *\)/,"")
  s= s.gsub(/<p> *<\/p>/,"")
  s=s.gsub(/<strong><font size="3">.*?<\/font><\/strong>/i,"")
  s=s.gsub(/(<br>)+/i,'\1')

  s=s.gsub(/\?/,".")
  s=s.gsub(/\''/,"''")
  s=s.gsub(/\'/,"'")
  s=s.gsub(/\\'/,"'") 
  s=s.gsub(/\\/,"") 

  
  
  
  s= s.strip 
end  # def Iv.descHtmlProcess(s)


def Iv.remove9ivImageAndLinkInHtml(s)
  if s.nil? 
  s=""
  end #if s.nil? 
  s=s.to_s
  s=s.gsub(/\[.*9iv.*\]/i, "")
  s=s.gsub(/<a *href=\"http:\/\/www.google.*9iv.*\<\/a\?>/i, "") 
  s=s.gsub(/<a *href=\"http:\/\/www.9iv.*\<\/a\?>/i, "")
  
  #s=s.gsub(/<img.*?9iv.*?>/i,"") #remove image in 9iv, enabel/disable depends need
  
  s=s.gsub(/<IMG height=20 alt="google.*?>/i,"")

end #def Iv.remove9ivImageAndLinkInHtml(s)

def Iv.replace9ivwithmyvpsoft(s)
  if s.nil? 
  s=""
 end #if s.nil? 
  s=s.to_s
  s=s.gsub(/9iv/i,"myvpsoft")
end #def Iv.replace9ivwithmyvpsoft(s)


def Iv.removespace(s)
  if s.nil? 
  s=""
  end #if s.nil? 
  return s.gsub(/ /,"")
end #def Iv.removespace(s)


def Iv.removeContinuesChat(s)
if s.nil? 
 s=""
end #if s.nil? 

s= s.gsub(/\s/, " ") #"s   ," => "s ,"
s= s.gsub(/ +([,.\?!'#%&()*+-\/:;<=>\?@\[\]\^_{}|~])/, '\1')   # "s ," => "s,"
s= s.gsub(/([,.!\?:;'"])+/, '\1')

#s= s.gsub(/([\?])+/, '\1')
#s= s.gsub(/([!])+/, '\1')
s= s.gsub(/([#])+/, '\1')
#s= s.gsub(/(['])+/, '\1')
s= s.gsub(/([%])+/, '\1')
s= s.gsub(/([&])+/, '\1')
s= s.gsub(/([(])+/, '\1')
s= s.gsub(/([)])+/, '\1')
s= s.gsub(/([#])+/, '\1')
s= s.gsub(/([*])+/, '\1')
s= s.gsub(/([+])+/, '\1')
s= s.gsub(/([-])+/, '\1')
#s= s.gsub(/([\/])+/, '\1') #http://www.sss
s= s.gsub(/([\\])+/, '\1') #http://www.sss
#s= s.gsub(/([:])+/, '\1')
#s= s.gsub(/([;])+/, '\1')
s= s.gsub(/([<])+/, '\1')
s= s.gsub(/([=])+/, '\1')
s= s.gsub(/([>])+/, '\1')
#s= s.gsub(/([\?])+/, '\1')
s= s.gsub(/([@])+/, '\1')
s= s.gsub(/([\[])+/, '\1')
s= s.gsub(/([\]])+/, '\1')
s= s.gsub(/([\^])+/, '\1')
s= s.gsub(/([_])+/, '\1')
s= s.gsub(/([{])+/, '\1')
s= s.gsub(/([}])+/, '\1')
s= s.gsub(/([|])+/, '\1')
s= s.gsub(/([~])+/, '\1')

return s
end


def Iv.sizeUnionMap(s)
  if s.nil? 
  s=""
  end #if s.nil? 
s=self.removespace(s).to_s
if  s==""
  return "Byte"
else
s=s[0].chr
s=s.to_s.upcase

sizemap={}
sizemap["B"]="Byte"
sizemap["M"]="MB"
sizemap["K"]="KB"
sizemap["G"]="GB"
sizemap["C"]="GB" #cd
sizemap["D"]="GB" #dvd

if sizemap[s].nil?
  return "MB"
else    
return sizemap[s]
end #if sizemap[s].nil?
end #if  s==""

end #def Iv.sizeUnionMap(s)



def Iv.jivCat2OscCat(cat)
  if cat.nil? 
 cat=""
end #if cat.nil? 


 if cat=="\320\320\322\265\310\355\274\376" #行业软件 
  return "APP"
elsif cat =="\315\274\320\316\315\274\317\361" #图形图像
 return "Photography"
elsif cat == "\261\340\263\314\277\252\267\242" #编程开发
  return "Programing"
 elsif cat ==  "\313\330\262\304\275\314\263\314" #素材教程
   return "Material"
 
 elsif cat == "Ebook\302\333\316\304" #ebook论文
   return "Ebook"
 
 elsif cat ==  "\306\344\313\373\310\355\274\376" #其他下载
   return "Misc"
elsif cat ==  "\266\340\303\275\314\345\300\340" #多媒体类
  return "MultiMedia"
elsif cat ==   "\317\265\315\263\271\244\276\337" #系统工具
  return "SysTools"
 
elsif cat == "\315\370\302\347\271\244\276\337" #网络工具
  return "Internet"
elsif cat == "\323\246\323\303\310\355\274\376" #应用软件
  return "App"

elsif cat == "\260\262\310\253\317\340\271\330" #安全相关
  return "Security"
elsif cat ==  "\323\316\317\267\323\351\300\326" #游戏娱乐
  return "Entertainment"
else 
  return "Misc"
end #if cat=="\320\320\322\265\310\355\274\376" #行业软件 
end #def Iv.jivCat2OscCat(s)



################ MOST IMPORT FUNCTION ############
def Iv.SaveID(ie, id)
  
  sid=id.to_s
  softid=sid.to_s
  maxMyID=Misc.getMaxMyID()
  newMyID=maxMyID.to_i + 1
  newMyID=newMyID.to_s  
  
  

  # remove because 9iv reuse softid -ryan20090727
  #if !(Misc.hasID(sid).to_s == "0")
  #  puts "softid already existed in unidb"
  #  return "0"
  #end
  
  
softPage="http://www.9iv.com/down/soft/"+softid+".htm"
#ie = Watir::IE.new
ie.goto softPage

 if ie.title.include?("E\316\254") #if the page title include "E维",非blank, 非页面不存在

#软件名称
softname=ie.title
softname=self.softnameProcess(softname)
softname=softname.gsub(/- E,,/,"")

softname=softname.strip


#软件分类
 a=ie.table(:id,"Table6")
 cat=a.link(:index,3).text
 category = self.jivCat2OscCat(cat)
 
#软件描述
 a=ie.table(:id,"Table20")
 
descHtml=a.html
descText=a.text

#puts "===1==="
#puts descHtml

#puts "===1========"
#puts descText
 
#descHtml=self.dbsc2onespace(descHtml)
#descHtml=Misc.removeCrackerOrg(descHtml)
#descHtml=self.remove9ivImageAndLinkInHtml(descHtml)
#descHtml=self.descHtmlProcess(descHtml)
#descHtml=self.replace9ivwithmyvpsoft(descHtml)
descHtml=self.descHtmlProcess(descHtml)
descHtml=descHtml.strip

#puts "===1.5==="
#puts descHtml




descText=self.dbsc2onespace(descText)
#descText=descText.gsub(/:/,"") #ryan, notwork, removed http://
#puts descText
descText= self.descTextProcess(descText)
#puts "===2========"
#puts descText
descText=descText.strip



infotab=ie.table(:id,"Table26")

#regdate
regdate=infotab.row(:index,5).text
regdate=Iv.removeDBCS(regdate)
regdate=regdate.split(" ")[0]
regDate=Iv.removespace(regdate)



#size
size=infotab.row(:index,3).text
size= Iv.removeDBCS(size).upcase





sizeunion=size.gsub(/[\d]|[.]|[,]/,"")
sizeunion=Misc.readytobeRegularExpress(sizeunion)
sizevalue=size.gsub(/#{sizeunion}/,"")
sizevalue=Iv.removespace(sizevalue)

if (sizeunion=="") or (sizeunion.nil?)
  sizeunion="M"
end #if sizeunion==""

if (sizevalue=="") or (sizevalue.nil?)
  sizevalue="0"
end #if sizevalue==""

sizeNumber=sizevalue.gsub(/[a-z|A-Z|\s]/,"")
sizeUnion=Iv.sizeUnionMap(sizeunion)




  puts "softid is: "+softid
  puts "softname is: "+softname
  puts "category is: "+category
  puts "regDate is: "+regDate
  puts "sizeNumber is: "+sizeNumber
  puts "sizeUnion is: "+sizeUnion



 sql1="INSERT INTO `description` ( `myID` , `html` , `txt` ) "
 sql1=sql1+"VALUES ("
 sql1=sql1 + \
      newMyID +",'"  \
      + Misc.txt2Sql(descHtml)+"','"  \
      + Misc.txt2Sql(descText)+"'"  \
      +"); "




#图片
imgarr=[]
ie.images.each { |i| 
if !i.src.to_s.include?("9iv")
#puts i.src.to_s 
imgarr << i.src.to_s 
end
}




fileCount="NULL"


sql0="INSERT INTO `main` \
    ( `myID` , `site` , `category` , `softuid` , `softname` , `register` , `sizevalue` , `sizeunion` , `filecount` , `adddaytime` ) "
 sql0=sql0+"VALUES ("
 sql0=sql0 + \
      newMyID +",'"  \
      + "9iv"+"','"  \
      + Misc.txt2Sql(category)+"','"  \
      + Misc.txt2Sql(softid.to_s)+"','"  \
      + Misc.txt2Sql(softname)+"','"  \
      + Misc.txt2Sql(regDate)+"','"  \
      + Misc.txt2Sql(sizeNumber)+"','"   \
      + Misc.txt2Sql(sizeUnion)+"','"  \
      + Misc.txt2Sql(fileCount.to_s)+"','"   \
      + Misc.datenow()+"'" \
      +"); "
 

#ryan comment below three line because main migration 9iv have finished on 20090905.
#if !(Misc.hasSoftName(softname.to_s).to_s =="0")
# Misc.delBySoftName(softname.to_s)
#end
 

 if Misc.hasSoftName(softname.to_s).to_s=="0"  #9iv does not apply Misc.hasID(softid.to_s).to_s=="0"
     Misc.dbprocess(sql0) 
     puts "inserted " +softname.to_s+"to Main table"
 
     system("ruby C:\\ruby_project\\9iv_unidb_dlpathmap.rb " + newMyID)
     puts "insert download path to dlpathmap table"
 





 
 
#if !Misc.hasmyIDDescription(newMyID)==
if Misc.hasmyIDDescription(newMyID).to_s == "0".to_s


Misc.dbprocess(sql1)
puts "inserted to description table"


  if !imgarr.empty?
  imgarr.each{|i| 
  sql2="INSERT INTO `images` ( `myID` , `imagepath` , `titleimage` , `HasSiteLogo` , `imgsizeinbyte` )"
  sql2=sql2+"VALUES ("
  sql2=sql2 + \
       newMyID +",'"  \
       + Misc.txt2Sql(i.to_s)+"','"  \
       +"0','0','0');"
  Misc.dbprocess(sql2)         
  }
end #if !imgarr.empty?

else 
puts newMyID+"have existed in description table"
end #if !Misc.hasmyIDDescription(newMyID)

 
 
 else # if Misc.hasSoftName(softname.to_s).to_s=="0" 
 puts "have exists softname: "+softname.to_s
 end # if  Misc.hasSoftName(softname.to_s).to_s=="0" 


#ie.close


end # if ie.title.include?("E\316\254")







end #def SaveID()


def Iv.cygwindlname(s)
  if s.nil?
  s=""
  end #s.nil?

     s=s.gsub(/[-\/:\|&<>{}()]/," ")
     s=s.gsub(/[\[\]]/," ")
     s=s.gsub(/[?!@#$\%^&*|:\/_+]/," ")     
     s=s.gsub(/,/,"")  
     s=s.gsub(/  /," ")  
     s=s.gsub(/  /," ")  
     s=s.gsub(/  /," ")  
     s=s.gsub(/  /," ")  
     s=s.gsub(/  /," ") 
     s=s.gsub(/  /," ")        
     s=s.gsub(/^\s*/,"")  
     s=s.gsub(/\s*$/,"")  
     s=s.gsub(/\./,"")  
     s=s.gsub(/ /,"-")   

end #def Iv.cygwindlname(s)

def Iv.cygwindldate(s)

  if s.nil?
  s=""
end #s.nil?

s=s.to_s

s=s.gsub(/-01/,"-1")
s=s.gsub(/-02/,"-2")
s=s.gsub(/-03/,"-3")
s=s.gsub(/-04/,"-4")
s=s.gsub(/-05/,"-5")
s=s.gsub(/-06/,"-6")
s=s.gsub(/-07/,"-7")
s=s.gsub(/-08/,"-8")
s=s.gsub(/-09/,"-9")

end #def Iv.cygwindldate(s)






end #module Iv
  