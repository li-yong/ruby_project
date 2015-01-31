# -*- coding: utf-8 -*-

##################################
#
#  Update images.imgLclPath who contain 'ruby_project' to correct format.
#
##################################


$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"  

 
 
require 'misc'
  
 
         
  sql=" SELECT \`myID\` FROM \`images\` WHERE \`imgLclPth\` LIKE '%ruby_project%' "        
  sidarry=Misc.dbshowArray(sql)  
  sidarry.each {|myid| 
  
  oldname= Misc.dbshow("SELECT \`imgLclPth\`  FROM \`images\` WHERE \`myID\` = #{myid}")
  newname=oldname.gsub("c:\/ruby_project\/","")
  sql= "UPDATE \`images\` SET \`imgLclPth\` = \'#{newname}\' WHERE \`myID\`= '#{myid}' "
  
  #p sql
  Misc.dbprocess(sql)
  
  } #  sidarry.each {|myid| 

  