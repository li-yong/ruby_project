# -*- coding: utf-8 -*-



$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"  

$LOAD_PATH << "c:/ruby_project/lib"  


require 'misc'
require "zencart"


odbc="zencart.tpb"

sql="select myID from products where 1"
myarr=[]
myarr=Misc.dbshowMultiArrayCommon(odbc,sql)


myarr.each{|myid|
  puts "\n===myid #{myid}, #{odbc} === "
  Zencart.updateTitleImage(odbc,myid)
}












  