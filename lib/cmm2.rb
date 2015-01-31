module Cmm2  #Category  Map
$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"


#require "misc"
#require 'DBI'
#require "osc"
#require "iv"
#require "cmm"


def Cmm2.returnMacCatID(s)
  
 
  
 
  macappKWarry=[
        "app",
        "microsoft",
        "adobe",
        "corel",
        "Autodesk",
        "Luxology",
        "CAD",
        "CAM",
        "CAE",
        "ISO",
        "Internet",
        "Programing"      
        ]


macbookKWarry=[
        "book",\
        "magazine",\
        "document"]        

        
        
macgameKWarry=["game"]     
        
mactutorialsKWarry=[
        "Lynda",
        "Tutor",
        "Train",
        "FXphd",
        "AsileFX",
        "VTC",
        "Simply Maya",
        "Cartoon Smart",
        "3D Garage",
        "MacProVideo",
        "Gnomon"
        ]


macpluginsKWarry=["plugin"]

#---------------------End of KW ARRAY define ---------------------------    




macpluginsKWarry.each{|i|
if s.upcase.include?(i.upcase)
catID=self.getMacCatID("MACPlugins")
return  catID
end
} #



macappKWarry.each{|i|
if s.upcase.include?(i.upcase)
catID=self.getMacCatID("MACAPP")
return  catID
end
} # 


mactutorialsKWarry.each{|i|
if s.upcase.include?(i.upcase)
catID=self.getMacCatID("MACTUTORIAL")
return  catID
end
} #


macbookKWarry.each{|i|
if s.upcase.include?(i.upcase)
catID=self.getMacCatID("MACBOOK")
return  catID
end
} #

macgameKWarry.each{|i|
if s.upcase.include?(i.upcase)
catID=self.getMacCatID("MACGAME")
return  catID
end

} #



#ABOVE CATCH ALL FAILED, then put to default MACAPP category.
catID=self.getMacCatID("MACAPP")
return  catID


end #def Cmm2.returnMacCatID(s)
  




def Cmm2.publicgetcatID(sentence)
s=sentence
s=s.to_s
#---------------------Start of KW ARRAY define ---------------------------


macKWarry=[
        "mac",\
        "mactonish"\
        "apple"]  


ebookKWarry=[
        "book",\
        "magazine",\
        "document"]        

        
        
appKWarry=[
        "app",
        "microsoft",
        "adobe",
        "corel",
        "Autodesk",
        "Luxology",
        "CAD",
        "CAM",
        "CAE",
        "ISO",
        "Internet",
        "Programing"      
        ]
        
tutorialsKWarry=[
        "Lynda",
        "Tutor",
        "Train",
        "FXphd",
        "AsileFX",
        "VTC",
        "Simply Maya",
        "Cartoon Smart",
        "3D Garage",
        "MacProVideo",
        "Gnomon"
        ]
        
materials_Photography_KWarry=[
        "photo",
        "picture",
        "Izosoft",
        "BananaStock",
        "AsiaImageBank",
        "Lushpix",
        "Atmosphere Studio",
        "image",
        "FStop",
        "Pepin Press"]        
        
materials_Template_KWarry=[
        "template",\
        "TemplateMonster",\
        "DreamTemplate"]
        

materials_Video_KWarry=[
        "Rubberball",
        "Video",
        "Creatas" ]  
        
        
materials_KWarry=[ 
        "Juice",
        "volume",
        "TurboSquid",
        "DoschDesign",
        "Daz3D",
        "Artbeats",
        "GoMedia",
        "Evermotion",
        "AsileFX",
        "Softimage",
        "art",
        "Artville",
        "Lost Pencil",
        "AmbientLight",
        "MultiMedia",
        "Digital Hotcakes"]        
        
tDMax_Plugin_KWarry=["3dmaxplugin"]         
adobe_Plugin_KWarry=["adobeplugin"]   
avid_Plugin_KWarry=["avidplugin"]    
cinema_4D_Plugin_KWarry=["Cinema4DPlugin"]  
lightWave_Plugins_KWarry=["LW Plugin","Lightwave plugin"] 
maya_Plugins_KWarry=["MayaPlugin"]
archicad_Plugins_KWarry=["ArchicadPlugin"]
plugins_KWarry=["plugin"]

#---------------------End of KW ARRAY define ---------------------------
                
=begin        
catmap=["30"=>appKWarry,
             "28"=>tutorialsKWarry,
             "29"=>ebookKWarry,
             "36"=>materials_Photography_KWarry,
             "37"=>materials_Template_KWarry,
             "35"=>materials_Video_KWarry,\
             "31"=>materials_KWarry,\
             "42"=>tDMax_Plugin_KWarry,\
             "41"=>adobe_Plugin_KWarry,\
             "45"=>avid_Plugin_KWarry,\
             "46"=>cinema_4D_Plugin_KWarry,\
             "43"=>lightWave_Plugins_KWarry,\
             "44"=>maya_Plugins_KWarry,\
             "47"=>archicad_Plugins_KWarry,\
             "40"=>plugins_KWarry        
             ]
=end            
         
             
             
macKWarry.each{|i|
if s.upcase.include?(i.upcase)
catID=self.returnMacCatID(s)
return catID
end
} #
             

ebookKWarry.each{|i|
if s.upcase.include?(i.upcase)
catID=self.getcatID("ebook")
return  catID
end
} #


materials_Photography_KWarry.each{|i|
if s.upcase.include?(i.upcase)
catID=self.getcatID("Photography")
return  catID
end
} #


materials_Template_KWarry.each{|i|
if s.upcase.include?(i.upcase)
catID=self.getcatID("template")
return  catID
end
} #


materials_Video_KWarry.each{|i|
if s.upcase.include?(i.upcase)
catID=self.getcatID("Video")
return  catID
end
} #


materials_KWarry.each{|i|
if s.upcase.include?(i.upcase)
catID=self.getcatID("Materials")
return  catID
end
} #


tDMax_Plugin_KWarry.each{|i|
if s.upcase.include?(i.upcase)
catID=self.getcatID("3DMaxPlugin")
return  catID
end
} #



adobe_Plugin_KWarry.each{|i|
if s.upcase.include?(i.upcase)
catID=self.getcatID("AdobePlugin")
return  catID
end
} #


avid_Plugin_KWarry.each{|i|
if s.upcase.include?(i.upcase)
catID=self.getcatID("AvidPlugin")
return  catID
end
} #


cinema_4D_Plugin_KWarry.each{|i|
if s.upcase.include?(i.upcase)
catID=self.getcatID("Cinema4DPlugin")
return  catID
end
} #


lightWave_Plugins_KWarry.each{|i|
if s.upcase.include?(i.upcase)
catID=self.getcatID("LightWavePlugins")
return  catID
end
} #


maya_Plugins_KWarry.each{|i|
if s.upcase.include?(i.upcase)
catID=self.getcatID("MayaPlugins")
return  catID
end
} #


archicad_Plugins_KWarry.each{|i|
if s.upcase.include?(i.upcase)
catID=self.getcatID("ArchicadPlugins")
return  catID
end
} #

plugins_KWarry.each{|i|
if s.upcase.include?(i.upcase)
catID=self.getcatID("plugins")
return  catID
end
} #


             

appKWarry.each{|i|
if s.upcase.include?(i.upcase)
catID=self.getcatID("app")
return  catID
end
} # 


tutorialsKWarry.each{|i|
if s.upcase.include?(i.upcase)
catID=self.getcatID("tutorials")
return  catID
end
} #


catID=self.getcatID("app")
return  catID

end #def Cmm2.publicgetcatID(sentence)




#give a category name, return it's ID in string.
def Cmm2.getcatID(s)
 catID="30" #bydefault is APP cat 
   
 if s.nil? 
  s=""
end #if s.nil? 

s=s.to_s
if  s=="" or s=="null"
  return catID
end #if  s==""
  
s=s.to_s.upcase

catMap={}
catMap["Misc".upcase]="23" 
catMap["TUTORIALS".upcase]="28" 
catMap["EBOOK".upcase]="29" 
catMap["APP".upcase]="30" 
catMap["Materials".upcase]="31" 
catMap["MAC".upcase]="32" 
catMap["Linux".upcase]="33" 
catMap["Video".upcase]="35" 
catMap["Photography".upcase]="36" 
catMap["Template".upcase]="37"
catMap["Sound".upcase]="38" 
catMap["plugins".upcase]="40" 
catMap["AdobePlugin".upcase]="41" 
catMap["3DMaxPlugin".upcase]="42" 
catMap["LightWavePlugins".upcase]="43" 
catMap["MayaPlugins".upcase]="44" 
catMap["AvidPlugin".upcase]="45" 
catMap["Cinema4DPlugin".upcase]="46"
catMap["ArchicadPlugins".upcase]="47"


catMap["MACAPP".upcase]="68"
catMap["MACBOOK".upcase]="70"
catMap["MACGAME".upcase]="69"
catMap["MACOS".upcase]="67"
catMap["MACPlugins".upcase]="79"
catMap["MACTUTORIAL".upcase]="71" 

if !catMap[s].nil?
catID=catMap[s]
end #if !catMap[s].nil?


return catID
end #def self.getcatID(s)




def Cmm2.getMacCatID(s)
 
#give a MAC category name, return it's MAC ID in string.

 catID="68" #bydefault is MACAPP cat 
   
 if s.nil? 
  s=""
end #if s.nil? 

s=s.to_s
if  s=="" or s=="null"
  return catID
end #if  s==""
  
s=s.to_s.upcase

catMap={}
catMap["MACAPP".upcase]="68"
catMap["MACBOOK".upcase]="70"
catMap["MACGAME".upcase]="69"
catMap["MACOS".upcase]="67"
catMap["MACPlugins".upcase]="79"
catMap["MACTUTORIAL".upcase]="71" 

if !catMap[s].nil?
catID=catMap[s]
end #if !catMap[s].nil?


return catID
end #def self.getMacCatID(s)


end #end of the module