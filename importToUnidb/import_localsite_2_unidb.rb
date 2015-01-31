
$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
$LOAD_PATH << "c:/ruby_project/lib"

#require "watir"
require "misc"
require 'DBI'
require "osc"
require "wgiftlocal"




sql="SELECT `products_id` FROM `products_description` WHERE `products_id`> 31600 "
 
 
arr=Wgiftlocal.dbshowArray(sql)

arr.each {|x| print x;  print " ";
#print Wgiftlocal.getsize(x)[1]+" "; 
 Wgiftlocal.insert2unidb(x);
}

#Wgiftlocal.getsoftname(20810)}

#puts Wgiftlocal.getsoftname(20810)