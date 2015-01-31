# -*- coding: utf-8 -*-


$LOAD_PATH << File.dirname(__FILE__).to_s+"../lib"  
$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
$LOAD_PATH << "c:/ruby_project/lib"
load "stock.rb"
load "misc.rb"
#require 'FileUtils'
rstHash=Hash.new
rstHash2=Hash.new

=begin Comments
#Input: 
    fileBase="c:/stock/eval/#{tsname}_eval_last.txt"
    fileBuy="C:/stock/buy/#{tsname}_buy_last.txt"
    
#Output: C:\stock\result\OVERALL_result.txt 
         C:\stock\result\OVERALL_result_2011-02-10.txt
         fileResult="c:/stock/result/#{tsname}_result.txt"
=end Comments

tmpArr=[];tmpArr=Stock.getResult("J01_MACD",rstHash,rstHash2);rstHash=tmpArr[0];rstHash2=tmpArr[1]
tmpArr=[];tmpArr=Stock.getResult("J02_BuLinDai",rstHash,rstHash2);rstHash=tmpArr[0];rstHash2=tmpArr[1]
tmpArr=[];tmpArr=Stock.getResult("J03_QuXiangZhiBiao",rstHash,rstHash2);rstHash=tmpArr[0];rstHash2=tmpArr[1]
tmpArr=[];tmpArr=Stock.getResult("J04_GuaiLiXiTong",rstHash,rstHash2);rstHash=tmpArr[0];rstHash2=tmpArr[1]
tmpArr=[];tmpArr=Stock.getResult("J05_KDJXiTong",rstHash,rstHash2);rstHash=tmpArr[0];rstHash2=tmpArr[1]
tmpArr=[];tmpArr=Stock.getResult("J07_RongLiangBiLvXiTong",rstHash,rstHash2);rstHash=tmpArr[0];rstHash2=tmpArr[1]
tmpArr=[];tmpArr=Stock.getResult("J08_WeiLianXiTong",rstHash,rstHash2);rstHash=tmpArr[0];rstHash2=tmpArr[1]
tmpArr=[];tmpArr=Stock.getResult("J09_PaoWuZhuanXiangXiTong",rstHash,rstHash2);rstHash=tmpArr[0];rstHash2=tmpArr[1]
tmpArr=[];tmpArr=Stock.getResult("J10_JunXianXiTong",rstHash,rstHash2);rstHash=tmpArr[0];rstHash2=tmpArr[1]
tmpArr=[];tmpArr=Stock.getResult("J11_SuiJiZhiBiaoZhuanJia",rstHash,rstHash2);rstHash=tmpArr[0];rstHash2=tmpArr[1]
tmpArr=[];tmpArr=Stock.getResult("J12_QuShiZhiBiao",rstHash,rstHash2);rstHash=tmpArr[0];rstHash2=tmpArr[1]
tmpArr=[];tmpArr=Stock.getResult("J15_DongLianXian",rstHash,rstHash2);rstHash=tmpArr[0];rstHash2=tmpArr[1]
tmpArr=[];tmpArr=Stock.getResult("J16_XinLiXian",rstHash,rstHash2);rstHash=tmpArr[0];rstHash2=tmpArr[1]
tmpArr=[];tmpArr=Stock.getResult("J17_BianDongSuLv",rstHash,rstHash2);rstHash=tmpArr[0];rstHash2=tmpArr[1]
tmpArr=[];tmpArr=Stock.getResult("J18_XiangDuiQiangRuoZhiBiao",rstHash,rstHash2);rstHash=tmpArr[0];rstHash2=tmpArr[1]



fileAllResult="c:/stock/result/OVERALL_result.txt"
fileAllResultToday="c:/stock/result/OVERALL_result_"+Misc.datenow3+".txt"
FileUtils.rm(fileAllResult) if File.exist?(fileAllResult)
FileUtils.rm(fileAllResultToday) if File.exist?(fileAllResultToday)
fhAllResult=File.new(fileAllResult,"a+")

rstHash.values.sort.uniq.each{|x|   
  
  rstHash.each{|key,value|  
    if value==x
      puts  fhAllResult.puts("\n===start")
      puts  fhAllResult.puts(key.to_s+"=>"+value.to_s)
      puts  fhAllResult.puts(rstHash2[key])
      puts  fhAllResult.puts("\n")
    end
    
    
  }#rstHash.each{
  
}#rstHash.values.sort.each


fhAllResult.close

FileUtils.cp fileAllResult, fileAllResultToday


exit
#stock test start
