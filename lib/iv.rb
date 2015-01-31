# -*- coding: utf-8 -*-
module Iv
  require 'misc'
  require 'sanitize'
  require "commondb"
  
  
  def Iv.removeDBCS_2(s)
    s=s.encode('utf-8').sub(/\p{Han}+/u, '')
  end
  
  def Iv.removeDBCS(s)
    if s.nil? 
      s=""
    end #if s.nil?   
    
    rtnmark="Rmark_RETURN_Rmark"
    slashmark="Smark_SLASHN_Smark"
    
   s= s.gsub(/\r/,rtnmark)
   s= s.gsub(/\n/,slashmark)
    
    
    
    s= s.gsub(/[^[:alnum:][:punct:] ]/,"")
    
   s= s.gsub(rtnmark,"\r")
   s= s.gsub(slashmark,"\n")
 
  end #def Iv.removeDBCS(s)
  
  def Iv.hasDBCS(s)
    if s.nil? 
      s=""
    end #if s.nil?
    
   if s.scan(/[^[:alnum:][:punct:] ]/).empty? == true
     rtn=false #no dbcs in the string
   else
     rtn=true
   end
    
    return rtn
  end

  
  
  def Iv.dbsc2onespace(s)
    if s.nil? 
      s=""
    end #if s.nil?
    s= s.gsub(/[^[:alnum:][:punct:] ]/," ")
    s= s.gsub(/ +/," ")
  end #def Iv.dbsc2space(s)
  
  
  def Iv.softnameProcessWithGoogleTrans(s)
    s=Misc.googletranslatetoenWeb(s)
    self.softnameProcess(s)
  end #def Iv.softnameProcessWithGoogleTrans(s)
  
  
  def Iv.softnameProcess(s)
    if s.nil? 
      s=""
    end #if s.nil?   
    if s.include?(" - E")
      ri=s.rindex(" - E")
      s=s[0..ri]
      Misc.removeWindowsInvalidCharFileName(s)
    end 
    
   
    
    s=s.gsub(/Simplified Chinese/i,"Multilingual")
    s=Misc.removeKW(s)
    s=Misc.googletranslatetoen(s)
    s=self.removeDBCS(s)
    s=self.removeContinuesChat(s)
    s=s.gsub("\( \)","")
    # sleep 1000;
    
    #s=s.gsub(/(.*)/,"")
    #s=s.gsub(/(.*)/,"")
    s=s.gsub(/\(\)/,"") #remove empty embrace
    return s
  end #def Iv.softnameProcess(s)
  
  
  def Iv.descTextProcess(s)
    if s.nil? 
      s=""
    end #if s.nil?   
    
    
    s=Sanitize.clean(s,  :output => :html,  :elements => [''])  
    
    #s=self.descHtmlProcess(s);   #cause google ban the script by overload. 
    s=s.gsub(/< +/,"<")  
    s=s.gsub(/ +>/,">")   
    s=s.gsub(/\//,"") 
    return s
  end #def Iv.descTextProcess(s)
  
  
  
  def Iv.descHtmlProcess(s)
    # s="!@#\$%^&*()_-=+:\"'<>?,./~`!@#\$%^&*()_-=+:\"'<>?,./~`!@#\$%^&*()_-=+:\"'<>?,./~`"
    if s.nil? 
      s=""
    end #if s.nil? 
    #s=Misc.cn2en(s)
    #Misc.saveTxt2File(s, "beforeTrans.iv.htm")
    s=Misc.googletranslatetoenWeb(s)
    s="" if s.nil?
    s=s.gsub(/Simplified Chinese/i,"Multilingual")
    #p "++++++++++++++ GTRANS"
    #p s
    s=Sanitize.clean(s,  :output => :html,  :elements => ['p','b', 'em', 'i', 'strong', 'u', 'br'])
    s=s.gsub(/P&gt;/i,"")
    s=s.gsub(/FONT&gt;/i,"")
    s=s.gsub(/DIV&gt;/i,"")
    s=s.gsub(/A&gt;/i,"")
    s=s.gsub(/SPAN&gt;/i,"")
    s=s.gsub(/STRONG&gt;/i,"")
    #p "=============SAN"
    #p s
    s=Misc.removeKW(s) 
    #p "===============REMOVEKW"
    #p s
    s=self.remove9ivImageAndLinkInHtml(s)
    #p "=================REMOVE9IV"
    #p s
    s=s.gsub(/http:\/\//i,"")
    s=s.gsub(/ftp:\/\//i,"")
    s=s.gsub(/mailto/i,"")
    #p "============= GSUB"
    #p s
    s= s.gsub(/\( *\)/,"")
    s= s.gsub(/<p> *<\/p>/,"")  #remove para ONLY have "space", that is empty paragraph
    s=s.gsub(/(<br>)+/i,'\1')  #merge continue <br>s to only one
     

    s= s.strip 
   #Misc.saveTxt2File(s, "afterTrans.iv.htm")
    rtn=s
    
    return rtn
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
    
    #s= s.gsub(/\s/, " ") #"s   ," => "s ,"
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
    s= s.gsub(/(<br>)+/, '\1')
   
    
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
    
    
    if cat=="\320\320\322\265\310\355\274\376" #???? 
      return "APP"
    elsif cat =="\315\274\320\316\315\274\317\361" #????
      return "Photography"
    elsif cat == "\261\340\263\314\277\252\267\242" #????
      return "Programing"
    elsif cat ==  "\313\330\262\304\275\314\263\314" #????
      return "Material"
      
    elsif cat == "Ebook\302\333\316\304" #ebook??
      return "Ebook"
      
    elsif cat ==  "\306\344\313\373\310\355\274\376" #????
      return "Misc"
    elsif cat ==  "\266\340\303\275\314\345\300\340" #????
      return "MultiMedia"
    elsif cat ==   "\317\265\315\263\271\244\276\337" #????
      return "SysTools"
      
    elsif cat == "\315\370\302\347\271\244\276\337" #????
      return "Internet"
    elsif cat == "\323\246\323\303\310\355\274\376" #????
      return "App"
      
    elsif cat == "\260\262\310\253\317\340\271\330" #????
      return "Security"
    elsif cat ==  "\323\316\317\267\323\351\300\326" #????
      return "Entertainment"
    else 
      return "Misc"
    end #if cat=="\320\320\322\265\310\355\274\376" #???? 
  end #def Iv.jivCat2OscCat(s)
  
  
  
  ################ MOST IMPORT FUNCTION ############
  def Iv.SaveID(ie, id, overwrite)
    sid=id.to_s
    softid=sid.to_s
    overwrite=false if (overwrite.nil? or overwrite != true)
    maxMyID=Misc.getMaxMyID()
    newMyID=maxMyID.to_i + 1
    newMyID=newMyID.to_s  
    
    
    
    # remove because 9iv reuse softid -ryan20090727
    #if !(Misc.hasID(sid).to_s == "0")
    #  puts "softid already existed in unidb"
    #  return "0"
    #end
    
    
    softPage="http://www.9iv.com/down/soft/"+softid+".htm"
    #ie = Watir::Browser.new
    ie.goto softPage
    
    
    #if ie.title.include?("E\316\254") #if the page title include "E?",?blank, ??????
    if ie.title.include?("E") #if the page title include "E?",?blank, ??????
      
      #????
      softname=ie.title
      softname=self.softnameProcess(softname)
      softname=softname.gsub(/- E,,/,"")
      
      softname=softname.strip

      
      #????
      a=ie.table(:id,"Table6")
      cat=a.link(:index,3).text
      category = self.jivCat2OscCat(cat)
      
      #????
      a=ie.table(:id,"Table20")
      
      descHtml=a.html
      
      infotab=ie.table(:id,"Table26")
      
      #regdate
      regdate=infotab.row(:index,5).text
      regdate=self.removeDBCS(regdate)
      regdate=regdate.split(" ")[0]
      regDate=self.removespace(regdate)
      
      
      
      #size
      size=infotab.row(:index,3).text
      size= self.removeDBCS(size).upcase
      
      
      
      
      
      sizeunion=size.gsub(/[\d]|[.]|[,]/,"")
      sizeunion=Misc.readytobeRegularExpress(sizeunion)
      sizevalue=size.gsub(/#{sizeunion}/,"")
      sizevalue=self.removespace(sizevalue)
      
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
      
      if ((Misc.hasSoftName(softname.to_s).to_s != "0") and (overwrite == true))
         tmpId=Misc.getMyID(softname.to_s)
         Misc.deleteBySID(tmpId)
      end

      
      if Misc.hasSoftName(softname.to_s).to_s=="0"  #9iv does not apply Misc.hasID(softid.to_s).to_s=="0"
        
        descHtml=self.descHtmlProcess(descHtml) 
        descText= self.descTextProcess(descHtml)
        
        sql1="INSERT INTO `description` ( `myID` , `html` , `txt` ) "
        sql1=sql1+"VALUES ("
        sql1=sql1 + \
        newMyID +",'"  \
        + Misc.txt2Sql(descHtml)+"','"  \
        + Misc.txt2Sql(descText)+"'"  \
        +"); "
        
        
        
        
        #??
        imgarr=[]
        ie.images.each { |i| 
          if !i.src.to_s.include?("9iv")
            #puts i.src.to_s 
            imgarr << i.src.to_s 
          end
        }
        
        
        
        
        fileCount="0"
        
        
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
        
        
        Misc.dbprocess(sql0) 
        puts "inserted " +softname.to_s+"to Main table"
        
        system("ruby -W0 C:\\ruby_project\\importToUnidb\\lib\\9iv_unidb_dlpathmap.rb " + newMyID)
        puts "inserted download path to dlpathmap table"
        
    
        #one problem above is above using string after google translate, it will not work if gt changed softname because cygwin download does not translate.
        #the workaround is have another script, read the db and change folder name.
        # To avoid judge ahead, this script need to be run after dl.sh.
        #  as 61.152.188.156, dl_9iv.sh everyday 8:00am
        #     61.152_xpvm, sync9ivdaily, everyday 10:00 am.
        system("ruby -W0 C:\\ruby_project\\importToUnidb\\lib\\9iv_syncPhysicalDirNameWithDlpathmap.rb " + newMyID)
        puts "sync physical download directory name with dlpathmap table"  
        
         Misc.insert2image(newMyID,imgarr)
         Misc.googleSearchTitleImg(newMyID)
         Misc.insert2featured(newMyID) 
        
        
        #if !Misc.hasmyIDDescription(newMyID)==
        if Misc.hasmyIDDescription(newMyID).to_s == "0".to_s
          
          
          Misc.dbprocess(sql1)
          puts "inserted to description table"
          
         
          

          
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
    s=s.gsub(/\(.*\)/, "")
    
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
  
  
  
  
def Iv.getApachePathMap()
hash9ivDirApache={}  
hash9ivDirApache["200503"]="E:/9iv_web/200503"
hash9ivDirApache["200504"]="E:/9iv_web/200504"
hash9ivDirApache["200505"]="E:/9iv_web/200505"
hash9ivDirApache["200506"]="E:/9iv_web/200506"
hash9ivDirApache["200507"]="E:/9iv_web/200507"
hash9ivDirApache["200508"]="E:/9iv_web/200508"
hash9ivDirApache["200509"]="E:/9iv_web/200509"
hash9ivDirApache["200510"]="E:/9iv_web/200510"
hash9ivDirApache["200511"]="E:/9iv_web/200511"
hash9ivDirApache["200512"]="E:/9iv_web/200512"




hash9ivDirApache["200601"]="E:/9iv_web/200601"
hash9ivDirApache["200602"]="E:/9iv_web/200602"
hash9ivDirApache["200603"]="E:/9iv_web/200603"
hash9ivDirApache["200604"]="K:/9iv_web/200604"
hash9ivDirApache["200605"]="K:/9iv_web/200605"
hash9ivDirApache["200606"]="K:/9iv_web/200606"
hash9ivDirApache["200607"]="K:/9iv_web/200607"
hash9ivDirApache["200608"]="K:/9iv_web/200608"
hash9ivDirApache["200609"]="K:/9iv_web/200609"
hash9ivDirApache["200610"]="K:/9iv_web/200610"
hash9ivDirApache["200611"]="K:/9iv_web/200611"
hash9ivDirApache["200612"]="K:/9iv_web/200612"
 
hash9ivDirApache["200701"]="K:/9iv_web/200701"
hash9ivDirApache["200702"]="K:/9iv_web/200702"
hash9ivDirApache["200703"]="K:/9iv_web/200703"
hash9ivDirApache["200704"]="K:/9iv_web/200704"
hash9ivDirApache["200705"]="K:/9iv_web/200705"
hash9ivDirApache["200706"]="K:/9iv_web/200706"
hash9ivDirApache["200707"]="K:/9iv_web/200707"
hash9ivDirApache["200708"]="K:/9iv_web/200708"
hash9ivDirApache["200709"]="E:/9iv_web/200709"
hash9ivDirApache["200710"]="E:/9iv_web/200710"
hash9ivDirApache["200711"]="E:/9iv_web/200711"
hash9ivDirApache["200712"]="E:/9iv_web/200712"
 
hash9ivDirApache["200801"]="E:/9iv_web/200801"
hash9ivDirApache["200802"]="E:/9iv_web/200802"
hash9ivDirApache["200803"]="E:/9iv_web/200803"
hash9ivDirApache["200804"]="E:/9iv_web/200804"
hash9ivDirApache["200805"]="E:/9iv_web/200805"
hash9ivDirApache["200806"]="E:/9iv_web/200806"
hash9ivDirApache["200807"]="E:/9iv_web/200807"
hash9ivDirApache["200808"]="E:/9iv_web/200808"
hash9ivDirApache["200809"]="E:/9iv_web/200809"
hash9ivDirApache["200810"]="E:/9iv_web/200810"
hash9ivDirApache["200811"]="E:/9iv_web/200811"
hash9ivDirApache["200812"]="E:/9iv_web/200812"
 
hash9ivDirApache["200901"]="H:/9iv_web/200901"
hash9ivDirApache["200902"]="H:/9iv_web/200902"
hash9ivDirApache["200903"]="H:/9iv_web/200903"
hash9ivDirApache["200904"]="H:/9iv_web/200904"
hash9ivDirApache["200905"]="G:/9iv_web/200905"
hash9ivDirApache["200906"]="G:/9iv_web/200906"
hash9ivDirApache["200907"]="G:/9iv_web/200907"
hash9ivDirApache["200908"]="G:/9iv_web/200908"
hash9ivDirApache["200909"]="G:/9iv_web/200909"
hash9ivDirApache["200910"]="G:/9iv_web/200910"
hash9ivDirApache["200911"]="G:/9iv_web/200911"
hash9ivDirApache["200912"]="G:/9iv_web/200912"
 
hash9ivDirApache["201001"]="G:/9iv_web/201001/"
hash9ivDirApache["201002"]="G:/9iv_web/201002/"
hash9ivDirApache["201003"]="G:/9iv_web/201003/"
hash9ivDirApache["201004"]="G:/9iv_web/201004/"
hash9ivDirApache["201005"]="G:/9iv_web/201005/"
hash9ivDirApache["201006"]="G:/9iv_web/201006/"
hash9ivDirApache["201007"]="G:/9iv_web/201007/"
hash9ivDirApache["201008"]="G:/9iv_web/201008/"
hash9ivDirApache["201009"]="G:/9iv_web/201009/"
hash9ivDirApache["201010"]="G:/9iv_web/201010/"
hash9ivDirApache["201011"]="G:/9iv_web/201011/"
hash9ivDirApache["201012"]="G:/9iv_web/201012"
 
hash9ivDirApache["201101"]="E:/9iv_web/201101"
hash9ivDirApache["201102"]="E:/9iv_web/201102"
hash9ivDirApache["201103"]="E:/9iv_web/201103"
hash9ivDirApache["201104"]="E:/9iv_web/201104"
hash9ivDirApache["201105"]="E:/9iv_web/201105"
hash9ivDirApache["201106"]="E:/9iv_web/201106"
hash9ivDirApache["201107"]="E:/9iv_web/201107"
hash9ivDirApache["201108"]="E:/9iv_web/201108"
hash9ivDirApache["201109"]="E:/9iv_web/201109"
hash9ivDirApache["201110"]="E:/9iv_web/201110"
hash9ivDirApache["201111"]="E:/9iv_web/201111"
hash9ivDirApache["201112"]="E:/9iv_web/201112"

return hash9ivDirApache
end #def Iv.getApachePathMap()



def Iv.renamedlPathDirToDBSetting(myID)
  sqlgetarry="SELECT * FROM `dlpathmap` WHERE `myID` = \""+myID+"\" "
resultarr=Misc.dbshowWholeArray(sqlgetarry)


#puts resultarr; 
resultarr.each{|row|
 #while row=resultarr.fetch do
  myID= row[0] 
  protocol=row[1]
  server=row[2]
  port=row[3]
  ppath=row[4]
  path=row[5]
  valid=row[6]
  
ivid=Misc.getSoftuid(myID)

hash9ivDirApache=Iv.getApachePathMap()

physicaPath=hash9ivDirApache[ppath]
if hash9ivDirApache[ppath].nil? or path.nil?
  puts "error when processing myID #{myID},hash9ivDirApache[ppath] or path is nil,hash9ivDirApache[ppath]:#{physicaPath},path: #{path} "
  next
end
 
   #suppose this program running on 61.152.188.156  
   absDirDB=hash9ivDirApache[ppath]+"/"+path
   absDirMathPattern=hash9ivDirApache[ppath]+"/"+ path.split("/")[0]+"/id"+ivid.to_s+"_*"
   
   arrSame=Dir.glob(absDirDB)
   arrMath=Dir.glob(absDirMathPattern)
   
   
   if !arrSame.empty? 
     puts "physical dir same as dlpathmap, update dlpathmap to 1"
      sql="update `dlpathmap` set `valid`='1' where myid=#{myID} "
      Misc.dbprocess(sql)
   elsif !arrMath.empty?
     puts "pyhsical dir Not same as dlpathmap, rename the dir to sync with db"     
     physcialPath=arrMath[0]
     dosOld=physcialPath.gsub("/","\\")
     dosNew=absDirDB.gsub("/","\\")
     dosNew=dosNew.split("\\")[-1]
     puts "rename #{dosOld} #{dosNew} "
     system("rename  #{dosOld} #{dosNew}")
     sql="update `dlpathmap` set `valid`='1' where myid=#{myID} "
     Misc.dbprocess(sql)
   else
      puts "No dir match pattern #{absDirMathPattern} , update dlpathmap valid to 0"
      sql="update `dlpathmap` set `valid`='0' where myid=#{myID} "
      Misc.dbprocess(sql)
    end # if !arrSame.empty? 


## end #    while row=resultarr.fetch do
  
 } #resultarr.each{|row|
end #def Iv.renamedlPathDirToDBSetting(myID)

 
end #module Iv
