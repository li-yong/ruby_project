# -*- coding: utf-8 -*-


  
$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"  
$LOAD_PATH << "c:/ruby_project/lib"

#require 'iv'
require 'misc'
#require 'DBI'
#require "watir"
#require "verycd"
#ie= Watir::Browser.new




maxid=Misc.getMaxFeaturedID()


maxid="0" if maxid==""

  sql="SELECT `myID` FROM `main` WHERE `myID` > #{maxid}"


arr=Misc.dbshowArray(sql)

arr.each {|myid| 
Misc.insert2featured(myid)
}














