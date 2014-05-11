$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
require "misc"
require "iv"
require "osc"


myID=ARGV[0]

if myID.nil?
  sqlgetarry="SELECT `myID` , `softuid` , `softname`,`register` FROM `main` WHERE `site` = \"9iv\" "
  else
  sqlgetarry="SELECT `myID` , `softuid` , `softname`,`register` FROM `main` WHERE `myID` = \""+myID+"\" "
end


resultarr=Misc.dbshowWholeArray(sqlgetarry)
row=resultarr
  # while row=resultarr.fetch do
        myID= row[0][0]
        
if (Misc.hasdlpathmap(myID).to_s == "0".to_s)
        
        id= row[0][1]
        dlsoftname=Iv.cygwindlname(row[0][2])
        date= Iv.cygwindldate(row[0][3])
        path= date+"/"+"id"+id+"_"+dlsoftname
        
          sql="INSERT INTO `dlpathmap` ( `myID` , `protocol` , `server` , `port` , `ppath` , `path` )"
          sql=sql+"VALUES ('"
          sql=sql+myID.to_s.strip
          sql=sql+"', '"
          sql=sql+"http"
          sql=sql+"', '"
          sql=sql+"61.152.188.156"
          sql=sql+"', '"
          sql=sql+"8088"
          sql=sql+"', '"
          sql=sql+"gweb"
          sql=sql+"', '"
          sql=sql+path
          sql=sql+"');"
 
          Misc.dbprocess(sql)
          puts "33333"

         
else
puts "myID "+myID.to_s+" already existed in dlpathmap table"          
end  #if (Misc.hasdlpathmap(myid).to_s == "0".to_s) 
        
 # end #    while row=resultarr.fetch do
 
 



 
