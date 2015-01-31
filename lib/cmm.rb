module Cmm  # Manufactor Map
require "timeout"
require "misc"
require "iv"
require "net/http"
require "fileutils"
require 'net/ftp'
require 'Multi_FTP'
require 'FileUtils'


# public method
#from giving s, retrun a string ID of manufacture 
#s is a string, can be softname or other info
#eg. input "adobe cs3" will back "21"
#     input "adXobe cs3" will back "null" 
def Cmm.publicgetCommManu(sentense)
 manuname = self.commonManufacturesMap(sentense)
 manu_number = self.getmanuID(manuname)
 return manu_number
end #def Cmm.getCommManu(sentense)

#use to get torrent file content, then save to db.
def Cmm.getHttpContent(url)
  rtn="dlerr" #download eror
  begin
    print "    starting read url content: "+url[0..20]
    
    Timeout.timeout(30) {     
      url = URI.parse(url)
      req = Net::HTTP::Get.new(url.path)
      res = Net::HTTP.start(url.host, url.port) {|http|
        http.request(req)
      }
      rtn= res.body
    }# Timeout.timeout(3) { 
  rescue Exception
    puts "  Cmm.getHttpContent:  timeout 30s when read url content, url is: #{url}"
  end    
  
  return rtn
  
end  #def Cmm.getHttpContent(url)


#save http://img.jpg to a subfolder under 'folder', using first two digital of 'myid' as subfolder name.
def Cmm.saveHttpImg(myid,imglink,folder,indexnumberofarray)
rtn="dlerr" #download eror
imglink=self.mergeDupChrContinues(imglink,"/")
puts "imglink is #{imglink}"
b=imglink.split("/")
site=b[1]
imgpath="/"+b[2..b.length].join("/") 
b[-1]=".jpeg" if  b[-1].include?("?"); #google search image limited. not return ture iamge path

#puts "\t imgpath is #{imgpath}"
#puts "\t b[-1] is " + b[-1]


downfilename="id"+myid.to_s+"_"+indexnumberofarray.to_s+"_"+b[-1]
pdownloadfolder="c:/ruby_project/"
downfolder=folder+"/"+self.getMyIDSubfolderName(myid)


 fullsavepath=downfolder+"/"+downfilename
  

absFullSavePath=pdownloadfolder+fullsavepath
FileUtils.mkdir_p pdownloadfolder+downfolder

begin
print "    starting download img file "+imglink[0..20]
#print "    starting download img file "+imglink
 Timeout.timeout(30) { 
Net::HTTP.start(site) { |http|
  resp = http.get(imgpath)
  open(absFullSavePath, "wb") { |file|
    file.write(resp.body)
   }
}#Net::HTTP.start(site) { |http|

 }# Timeout.timeout(3) { 

rescue Exception
  puts "  Cmm.saveHttpImg:  timeout 30s when download img, continue next img"
end

if 	File.exist?(absFullSavePath) 
   filesize=File.size(absFullSavePath)
  if   filesize < 1024  #File.size return in byte
    File.delete(absFullSavePath)

    
    rtn="dlerr:imgtoosmall"
    puts "    Igm size #{filesize} <1024 (1k) or not existed,delete downloaded img"
   else
    print "    image was downloaded to "+absFullSavePath[0..35]+"..."
    rtn=fullsavepath
  end #    if 	File.size(fullsavepath) < 10240
else
  rtn="dlerr:imgnotdownload"
end #if 	File.exist?(fullsavepat




return rtn #return dlpath when success,  "dlerr" when fail.
  
end #def Cmm.saveHttpImg(myid,imgurl,folder)











#save http://img.jpg to a subfolder under 'folder', using first two digital of 'myid' as subfolder name.
def Cmm.saveHttpImg_branding(myid,imglink,folder,indexnumberofarray,i_timeout,i_imgSizeNoLessThan)


 return imglink if imglink.index(/[^[:alnum:][:punct:] ]/) != nil  #return local image same as remote image when img contain DBCS.


rtn="dlerr" #download eror
imglink=self.mergeDupChrContinues(imglink,"/")
 

 return rtn if imglink.nil?
 return rtn if imglink==""
 
 #then replace remoteImage to localImaeg ,will keep remoteImage not change.
 
 #puts "\n\n image link is start#{imglink}end"

b=imglink.split("/")
site=b[1]




imgpath="/"+b[2..(b.length-1)].join("/") 
  
downfilename="id"+myid.to_s+"_"+indexnumberofarray.to_s+"_"+b[-1]
pdownloadfolder="c:/ruby_project/"
downfolder=folder+"/"+self.getMyIDSubfolderName(myid)


fullsavepath=downfolder+"/"+downfilename
absFullSavePath=pdownloadfolder+fullsavepath
FileUtils.mkdir_p pdownloadfolder+downfolder

begin
print "    starting download img file "+imglink.gsub(/http:\//i,"http://")[0..10]
 Timeout.timeout(i_timeout.to_i) { 
Net::HTTP.start(site) { |http|
  resp = http.get(imgpath)
  open(absFullSavePath, "wb") { |file|
    file.write(resp.body)
   }
}#Net::HTTP.start(site) { |http|

 }# Timeout.timeout(3) { 

rescue Exception
  puts "timeout "+ i_timeout.to_s+" when download img, continue next img"
end

if  File.exist?(absFullSavePath) 
   filesize=File.size(absFullSavePath)
  if   filesize < i_imgSizeNoLessThan.to_i  #File.size return in byte
    File.delete(absFullSavePath)

    
    rtn="dlerr:imgtoosmall"
    puts "Igm size #{filesize} < "+i_imgSizeNoLessThan.to_s+" byte or not existed,delete downloaded img"
   else
    puts "    image was downloaded to "+absFullSavePath[0..35]+"..."
    rtn=fullsavepath
  end #    if   File.size(fullsavepath) < 10240
else
  rtn="dlerr:imgnotdownload"
end #if   File.exist?(fullsavepat




return rtn #return dlpath when success,  "dlerr" when fail.
  
end #def Cmm.saveHttpImg_branding(myid,imglink,folder,indexnumberofarray,i_timeout,i_imgSizeNoLessThan)





#merge continues duplicate char to only one. http://1.com///b --> http:/1.com/b
def Cmm.mergeDupChrContinues(string, char)
  while string.include? char+char
    string=string.gsub(char+char, char)
  end
  return string
end





#merge continues duplicate char to only one. "<b>  </b> <b> </b> <b></b>"->"<b></b>"
def Cmm.mergeDupChrContinuesTag(string, char)
  string=string.gsub(/\s+/," ")
  while string.include? char+" "+char
    string=string.gsub(char+" "+char, char)
  end
  return string
end

#if myid=1, return "001", myid=12, return "012", myid=123,return "123"
#used for sperate store myid image file in different folder.
def Cmm.getMyIDSubfolderName(myid)
subfolder=myid.to_s[0..2] #first two char
if subfolder.length == 1  
  subfolder="00"+subfolder
end

if subfolder.length == 2  
  subfolder="0"+subfolder
end 

return subfolder
end #def Cmm.getMyIDSubfolderName(myid)



#### used by self.getCommManu
#from giving s (manufacture name), back manu ID in OSC.
def Cmm.getmanuID(s)
 if s.nil? 
  s=""
 end #if s.nil? 

s=Iv.removespace(s).to_s
if  s=="" or s=="null"
  return "null"
end #if  s==""
  
s=s.to_s.upcase

manuMap={}
manuMap["ADOBE".upcase]="21"
manuMap["Acrobat".upcase]="21"
manuMap["maya".upcase]="21"

manuMap["microsoft".upcase]="22"
manuMap["autodesk".upcase]="23"
manuMap["corel".upcase]="24"
manuMap["luxology".upcase]="25"
manuMap["apple".upcase]="62"
manuMap["roxio".upcase]="63"
manuMap["sonic".upcase]="63"
manuMap["solidworks".upcase]="64"
manuMap["bentley".upcase]="65"

manuMap["lynda.com".upcase]="8" 
manuMap["GnomonWorkshop".upcase]="9" 
manuMap["Gnomonology".upcase]="10" 
manuMap["FXphd".upcase]="11" 
manuMap["VTC".upcase]="12" 
manuMap["DigitalTutors".upcase]="13" 
manuMap["TotalTraining".upcase]="14" 
manuMap["SimplyMaya".upcase]="15" 
manuMap["3DTrainer".upcase]="16" 
manuMap["CartoonSmart".upcase]="17" 
manuMap["3DGarage".upcase]="18" 
manuMap["MacProVideo".upcase]="19" 
manuMap["Softimage".upcase]="28" 
manuMap["DigitalJuice".upcase]="29" 
manuMap["3DCONTENT".upcase]="30" 
manuMap["TurboSquid".upcase]="31" 
manuMap["DoschDesign".upcase]="32" 
manuMap["Daz3D".upcase]="33" 
manuMap["Artbeats".upcase]="34" 
manuMap["GoMedia".upcase]="35" 
manuMap["Evermotion".upcase]="36" 
manuMap["AsileFX".upcase]="37" 
manuMap["3DTotal".upcase]="38" 
manuMap["Digital Art".upcase]="39" 
manuMap["3DBank".upcase]="40" 
manuMap["ImageCel".upcase]="41" 
manuMap["Imagemore".upcase]="42" 
manuMap["Artville".upcase]="43" 
manuMap["iStockPhotos".upcase]="44" 
manuMap["LostPencil".upcase]="45" 
manuMap["fstopimages".upcase]="46" 
manuMap["AmbientLight".upcase]="47" 
manuMap["DigitalHotcakes".upcase]="48" 
manuMap["Motionloops".upcase]="49" 
manuMap["MarlinStudios3D".upcase]="50" 
manuMap["CircaArt".upcase]="51" 
manuMap["Rubberball".upcase]="52" 
manuMap["VideoCopilot".upcase]="53" 
manuMap["Creatas".upcase]="54" 
manuMap["PHOTOSTOCK".upcase]="55" 
manuMap["PhotoSpin".upcase]="56" 
manuMap["PepinPress".upcase]="57" 
manuMap["PhotoAlto".upcase]="58" 
manuMap["TemplateMonster".upcase]="59" 
manuMap["DreamTemplate".upcase]="60" 

if manuMap[s].nil?
  return ""
else
return manuMap[s]
end #if manuMap[s].nil?


end #CMM.getmanuID







#### used by self.getCommManu
#  input "adobe cs3" will return "ADOBE"
def Cmm.commonManufacturesMap(s)
 s=Iv.removespace(s)
 s=s.upcase
  
  manuarry=[
        "3D Bank",\
        "3D CONTENT",\
        "3D Garage",\
        "3D Total",\
        "3D Trainer",\
        "Adobe",\
        "AmbientLight",\
        "Artbeats",\
        "Artville",\
        "AsileFX",\
        "Autodesk",\
        "Cartoon Smart",\
        "Circa Art",\
        "Corel",\
        "Creatas",\
        "Daz3D",\
        "Digital Art",\
        "Digital Hotcakes",\
        "Digital Juice",\
        "Digital Tutors",\
        "DoschDesign",\
        "DreamTemplate",\
        "Evermotion",\
        "fstopimages",\
        "FXphd",\
        "Gnomon Workshop",\
        "Gnomonology",\
        "GoMedia",\
        "ImageCel",\
        "Imagemore",\
        "iStockPhotos",\
        "Lost Pencil",\
        "Luxology",\
        "Lynda.com",\
        "MacProVideo",\
        "Marlin Studios 3D",\
        "Microsoft",\
        "Motionloops",\
        "Pepin Press",\
        "PhotoAlto",\
        "PhotoSpin",\
        "PHOTOSTOCK",\
        "Rubberball",\
        "Simply Maya",\
        "Softimage",\
        "TemplateMonster",\
        "Total Training",\
        "TurboSquid",\
        "Video Copilot",\
        "Apple",\
        "Autodesk",\
        "corel",\
        "VTC"   
]

manuarry <<     "maya"
manuarry <<     "IDM"
manuarry <<     "Roxio"
manuarry <<     "solidworks"
manuarry <<     "bentley"
manuarry <<     "acrobat"


rtrn="null"
manuarry.each{|i|
i=Iv.removespace(i).upcase
if s.include?(i)
  rtrn = i
  break
end  #if s.upcase.include?(Iv.removespace(i.upcase))
} #manuarry.each{|i|

return rtrn
  
end #def  Cmm.commonManufacturesMap(s)





def Cmm.ftpUploadFolder(server,port,username,password,lPath,rPath)
  #upload localFileArray to rPath
  #lPath is local OS system path WITHOUT Driver. Windows folder c:\ruby_project\lib should using "\\ruby_project\\lib"
  #      Current script set works for Windows. to use Linux client, switch Multi_FTP.rb setting to windows. 
  #rPath is path in FTP server, not OS system path.  If this directory not existed in ftp server, then it will be created.
  #in the test, text file and binary file are both works finein ftp server after upload. 
  #this function can not used to upload local file to remote.  
  #-------------------
  # example:
  #  lPath="\\ruby_project\\lib"  
  #  rPath="/home/hi"
  #  username="ryan"
  #  password="1"
  #  server="localhost"
  #  port="21"
  #  Cmm.ftpUploadFolder(server,port,username,password,lPath,rPath)
  #-------------------- 
  
  ftp = Multi_FTP.new()
  ftp.setup(username,password,server,port)
  ftp.go_send(lPath,rPath)
  ftp.close_ftp()
end #def Cmm.ftpUploadFolder(server,port,username,password,lPath,rPath)




def Cmm.ftpGetFolder(server,port,username,password,lPath,rPath)
  ftp = Multi_FTP.new()
  ftp.setup(username,password,server,port)
  ftp.go_get(lPath,rPath)
  ftp.close_ftp()
end #def Cmm.ftpGetFolder(server,port,username,password,lPath,rPath)



def Cmm.ftpDeleteFolder(server,port,username,password,rPath)
  ftp = Multi_FTP.new()
  ftp.setup(username,password,server,port)
  ftp.delete_director(rPath)
  ftp.close_ftp()
end #def Cmm.ftpDeleteFolder(server,port,username,password,lPath,rPath)


#click one link but not directly ie.goto, it avoid hang during ie.goto
 def Cmm.ieGotoNoWait(ie,url)
 

 
url=url.to_s


html="<a href=\"#{url}\"  >#{url}</a>"
file="c:/tmp/cmm.launchIEwithTimeout.html"
Misc.saveTxt2FileOverwrite(html,file)


#puts "Cmm.ieGotoNoWait,prepared link html"
 
iefile="file:///"+file
ie.goto(iefile)
ie.link(:index,1).click!

#puts "Cmm.ieGotoNoWait,clicked link without wait, now sleep 2"
sleep 2

 
 
#File.delete(file)
#return ie
   
end  # def Cmm.ieGotoNoWait(ie,url)

 

 

 
  def Cmm.launchIEwithTimeout(ie, check_url, timeout)

check_url = check_url.to_s
timeout=timeout.to_i

#puts "+++++++++ OPEN IE WITH Timeout"
#puts "timeout is set to #{timeout}"



#begin
  startTime= Time.now
  #puts "Cmm.launchIEwithTimeout, start loading page at #{startTime} "

# Timeout::timeout(timeout) do
  
  self.ieGotoNoWait(ie,check_url)
 (0..timeout).each{|sec| 
 
    #puts ie.status.downcase+sec.to_s; 
    if ie.status.downcase != "done" ; 
       puts "    #{sec} of #{timeout}, ie status is not done:"+ie.status[0..10] ; 
       sleep 1;
    else
       #print "ie status is done: "+ie.status 
       break
   end
 } #(0..timeout).each{|sec| 
   


 if ie.status.downcase != "done"
     ie.focus
     ie.send_keys("{ESC}{ESC}{ESC}{ESC}{ESC}")
     puts "    sent ESC to ie, ie staus is "+ie.status
 end
 
 print "    ie status now is: "+ie.status+"." 
  
  
 endtime = Time.now
 deltatime = Time.now-startTime
 puts "    used #{deltatime} seconds to load page"
 
 
 #puts "    check ie title"
 if ie.title.downcase=="cannot find server"
    ie.refresh
    puts "    ie title is cannot_find_server, try refreshed one time, no more action."
 end

#puts ie.check_for_http_error()
#end   #Timeout::timeout(timeout) do

#rescue Exception => e
# endtime = Time.now
# deltatime = Time.now-startTime
# ie.focus
# ie.send_keys("{ESC}{ESC}{ESC}{ESC}{ESC}")

#puts "    exception raised, until #{endtime}, used #{deltatime} seconds , page not finished loading, sent ESC to ie, ie status now is "+ie.status

#end

end # def launchIEwithTImeout(ie, check_url, timeout)



#-----------------------------------------------------------------------------------------------------------------------------------
end #module CMM