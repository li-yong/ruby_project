
$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
module Wgiftlocal
require 'DBI'
require 'iv'
require 'cmm'
require 'cmm2'
require 'Misc'

#back one column  array with selectsql result
def Wgiftlocal.dbshowArray(selectsql)
  #selectsql=self.txt2Sql(selectsql.to_s)  
  resultarr=[]
  #puts selectsql
  dbh = DBI.connect('DBI:ODBC:wgift_osdb','root','fav8ht39')
  sth = dbh.prepare(selectsql)
  sth.execute
   while row=sth.fetch do
        #p row[0]
        resultarr << row[0]
  end
    
   #puts sth
  dbh.disconnect if dbh
  
  if resultarr.length > 0
  return resultarr
  else
  return ""
  end#  if resultarr.length > 0
end#def Misc.dbshowArray(selectsql)





#back first record with selectsql result
def Wgiftlocal.dbshow(selectsql)
  #selectsql=self.txt2Sql(selectsql.to_s)  
  resultarr=[]
  #puts selectsql
  dbh = DBI.connect('DBI:ODBC:wgift_osdb','root','fav8ht39')
  #dbh = DBI.connect('DBI:ODBC:unidb','ryanTest2','AppleQ3Aj8X4dE')
  #dbh = DBI.connect('DBI:ODBC:unidb_testuse','root','fav8ht39')
  sth = dbh.prepare(selectsql)
  sth.execute
   while row=sth.fetch do
        #p row
        resultarr << row
    end
   
  dbh.disconnect if dbh
  
  if resultarr.length > 0
  return resultarr[0][0].to_s
  #puts resultarr[0][0]
  else
  return ""
  end#  if resultarr.length > 0
end#def Misc.dbshow(selectsql)





def Wgiftlocal.getsoftname(sid)
  sql="SELECT `products_name` FROM `products_description` WHERE `products_id`="+sid.to_s
  self.dbshow(sql)
end #def Wgiftlocal.getsoftname(sid)


def Wgiftlocal.getsize(sid)
   pattern="Software Name.*software size.*Download.*from our site"
  sql="SELECT `products_description` FROM `products_description` WHERE `products_id`="+sid.to_s
  
  result=self.dbshow(sql)
 # result=result =~/#{pattern}/
 #result=result=~/Software Name/
  send=result =~/<\/font><\/strong> from our site/
  
  if send.nil? or send==""
    return ["0","MB"]
  end #  if send.nil?
  
  
  #puts "send" + send.to_s
  result=result[0,send]
  softname=result.split("nbsp;")[0]
  softsize=result.split("nbsp;")[1]
  
  softsize_start=softsize =~/ff0000>/
  softsize_end=softsize =~/<\/font><p>/
  
  if softsize_start.nil?   or softsize_end.nil? 
      return ["0","MB"]
  end #  if softsize_start.nil?   or softsize_end.nil? 
    
    
  softsize=softsize[softsize_start+7,softsize_end-softsize_start-7].upcase
  softsize=Iv.removeDBCS(softsize)
  softsize=Iv.removespace(softsize)
  
 sizevalue=softsize.gsub(/[A-Za-z]/,"")
 sizeunion=softsize.gsub(/\d|\./,"")
 
 if sizevalue.nil? or sizevalue==""
   sizevalue=2
  end # if sizevalue.nil? or sizevalue==""
 
 sizeunion= Iv.sizeUnionMap(sizeunion)
 
 
 return [sizevalue,sizeunion]
  
end #def Wgiftlocal.getsize(sid)



def Wgiftlocal.getsizeInBytes(products_sizenum,products_sizeunion)
  products_sizenum=products_sizenum.to_i
  products_sizeunion=products_sizeunion.to_s
  
  case products_sizeunion
    when "Byte"
        return products_sizenum*1
    when "KB"
        return products_sizenum*1024    
    when "MB"
        return products_sizenum*1024*1024    
    when "GB"
        return products_sizenum*1024*1024*1024
      end #case products_sizeunion
end #def Wgiftlocal.getsizeInBytes
  


def Wgiftlocal.insert2unidb(sid)
softname=getsoftname(sid)
softsizevalue=self.getsize(sid)[0]
softsizeunion=self.getsize(sid)[1]


#softcategory=Cmm2.publicgetcatID(softname)
#softmanu=Cmm.publicgetCommManu(softname)

#puts softsizevalue
#puts softsizeunion
#puts softname

sizeinbyte=self.getsizeInBytes(softsizevalue,softsizeunion)
price=Osc.calcprice(sizeinbyte)

  maxMyID=Misc.getMaxMyID()
  newMyID=maxMyID.to_i + 1


self.insert2unidb_maintable(newMyID,"","",softname,"",softsizevalue,softsizeunion,"")




end #def Wgiftlocal.insert2unidb(sid)











def Wgiftlocal.insert2unidb_maintable(newMyID,category,softid,softname,regDate,sizeNumber,sizeUnion,fileCount)
 
sqlM=""
sqlM="INSERT INTO `main` \
    ( `myID` , `site` , `category` , `softuid` , `softname` , `register` , `sizevalue` , `sizeunion` , `filecount` , `adddaytime` ) "
 sqlM=sqlM+"VALUES ("
 newMyID=newMyID.to_s
 sqlM=sqlM + \
      newMyID +",'"  \
      + "t42"+"','"  \
      + Misc.txt2Sql(category)+"','"  \
      + Misc.txt2Sql(softid.to_s)+"','"  \
      + Misc.txt2Sql(softname)+"','"  \
      + Misc.txt2Sql(regDate)+"','"  \
      + Misc.txt2Sql(sizeNumber)+"','"   \
      + Misc.txt2Sql(sizeUnion)+"','"  \
      + Misc.txt2Sql(fileCount.to_s)+"','"   \
      + Misc.datenow()+"'" \
      +"); "     

   
 if Misc.hasSoftName(softname.to_s).to_s=="0".to_s
 Misc.dbprocess(sqlM) 
 puts "executed:  " +sqlM
 else 
   puts softname.to_s + " existed in unidb"
 end # if Misc.hasSoftName(softname.to_s).to_s=="0".to_s
end #def Wgiftlocal.insert2unidb_maintable


end #module Wgiftlocal
