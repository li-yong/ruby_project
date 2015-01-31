# -*- coding: utf-8 -*-


$LOAD_PATH << File.dirname(__FILE__).to_s+"../lib"  
$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
$LOAD_PATH << "c:/ruby_project/lib"
load "stock.rb"
##dbFileIN="c:/stock/result/OVERALL_result.in"


odbc="stock"


#Input "c:/stock/result/OVERALL_result.txt" 
#Output "c:/stock/result/OVERALL_result.in" and "c:/stock/result/OVERALL_result_2011_02-05.in"
print "--- GENERATTE MAKEINPUT FILE:"
dbFileIN=Stock.inSertDB_makeInputFile
puts " [DONE] "

print "\n--- CHECK TODAY's BUY: "
Stock.insertDB_insertTodaySuggestion2HoldstaticTable(odbc,dbFileIN)   
puts " [DONE] "

print "\n--- UPDATE TODAY's PROFIT STATUS : "
Stock.insertDB_insertTodayActualSituation2HoldDynamicTable(odbc)
puts " [DONE] "

print "\n--- CHECK TODAY's SALE: "
Stock.soldStock(odbc)
puts " [DONE] "


