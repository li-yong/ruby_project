# -*- coding: utf-8 -*-
$:.unshift File.expand_path(File.dirname(__FILE__) + "/./lib")

$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
$LOAD_PATH << "c:/ruby_project/lib"




require "Misc"
require "osc"


site="verycd"

odbc="zencart.#{site}"
sqldelarry="SELECT `myID` FROM `main` WHERE `site`=\"" + site +   "\""
resultarr=Misc.dbshowMultiResultsCommon(odbc,sqldelarry)
resultarr.each{|x| Zencart.removeMyID(odbc,x)}



