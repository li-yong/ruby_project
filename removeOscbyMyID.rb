# -*- coding: utf-8 -*-
$:.unshift File.expand_path(File.dirname(__FILE__) + "/./lib")

$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"




require "Misc"
require "osc"


site="verycd"
sqldelarry="SELECT `myID` FROM `main` WHERE `site`=\"" + site +   "\""
resultarr=Misc.dbshowMultiResults(sqldelarry)
resultarr.each{|x| Osc.removeMyID(x)}



