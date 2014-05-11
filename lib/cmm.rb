module Cmm  # Manufactor Map
require "misc"
require "iv"




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













#-----------------------------------------------------------------------------------------------------------------------------------
end #module CMM