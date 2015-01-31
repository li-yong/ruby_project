# -*- coding: utf-8 -*-


$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"  
$LOAD_PATH << "c:/ruby_project/lib"  

#=begin
#=end

require 'cmm2'
require 'cmm'
require 'misc'
load "taobaoGeneral.rb"


file="c:/tmp/cat103_lvWomanBag.txt" #file be parsed and processed. processed link will be removed from the file.
filebase=file+".BASE"  #base file that never change

File.copy(file,filebase)if !File.exist?(filebase)

catid= File.basename(file).split("cat")[1].split("_")[0]

linkarr=[]
fh=File.open(file); fh.each {|link| linkarr<< link }; fh.close
        

linkarr.each {|link|  
rtnlink=TaobaoGeneral.parseOneProduct(link,catid)
Misc.removeOneLineFromFile(file,rtnlink)
}

        
        
