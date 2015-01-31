# -*- coding: utf-8 -*-


$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"  
$LOAD_PATH << "c:/ruby_project/lib"  

#=begin
#=end

require 'cmm2'
require 'cmm'
require 'misc'
load "taobaoGeneral.rb"
load "GNC.rb"


link="file:///C:/gnc/test1.htm"
GNC.parseOneProduct(link)


exit




tmpfile="c:/tmp/tbTopWatch.txt"






 
tbTopLink_JinPingXiangBao="http://top.taobao.com/level3.php?cat=50006842"
tbTopLink_Watch="http://top.taobao.com/level3.php?cat=TR_PS&level3=50005700&from=search_result_query&toprankid=1288257009_SB_GJC_GZ_T&up=false"

tbTopLink_Watch="http://top.taobao.com/level3.php?cat=TR_PS&level3=50005700&up=true"

tbTopCat1stPage=tbTopLink_Watch
arr = TaobaoGeneral.getTopPageList(tbTopCat1stPage)

#only get hostest items in top 5 pages 
File.delete(tmpfile) if File.exists?(tmpfile) 
arr[0..4].each{|oneTbTopPageURL|    TaobaoGeneral.handleTopOnePage(oneTbTopPageURL,tmpfile)  }

exit

myfile = File.open(tmpfile)

myfile.each {|link| TaobaoGeneral.parseOneProduct(link) }

myfile.close
        
        
