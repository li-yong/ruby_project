

module Osc
require "misc"
require "iv"
require "cmm"
require "cmm2"

def Osc.cat2OscCatNum(site,sitecatname)
  site=site.to_s.downcase
  if site == "gfxnews"
    return self.gfxnewsCat2OscCat(sitecatname)
  elsif site == "9iv"
    return self.jivCat2OscCat(sitecatname)
    
  elsif site == "bitme"
     return self.bitmeCat2OscCat(sitecatname)
     
  elsif site == "verycd"
     return self.verycdCat2OscCat(sitecatname)
     
  else 
     return "23" ##23 is others cat in OSC
  end # if site == "gfxnews"
end #def Osc.cat2OscCatNum(site,sitecatname)



def Osc.verycdCat2OscCat(verycdcatname)
  verycdcatname=verycdcatname.to_s.downcase
   h = Hash.new("23") #23 is others cat in OSC
   h["OS".downcase] = 48.to_s #OS
   h["Internet".downcase] = 49.to_s #Internet
   h["Utility".downcase] = 50.to_s   #Utilities
   h["MutliMedia".downcase] = 51.to_s  #MutliMedia
   h["Productivity".downcase] = 52.to_s  #Business
   h["Program".downcase] = 53.to_s   #Developer Tools 
   h["Security".downcase] = 54.to_s  #Security
   h["App".downcase] = 30.to_s  #App   
 return h[verycdcatname]
end #def Osc.verycdCat2OscCat(bitmecatname)


def Osc.gfxnewsCat2OscCat(gfxnewscatname)
  gfxnewscatname=gfxnewscatname.to_s.downcase
   h = Hash.new("23") #23 is others cat in OSC
   h["TUTORIALS".downcase] = 21.to_s
   h["art"] = 22.to_s 
 return h[gfxnewscatname]
end #def Osc.gfxnewsCat2OscCat(gfxnewscatname)

def Osc.jivCat2OscCat(jivcatname)
  jivcatname=jivcatname.to_s.downcase
   h = Hash.new("23") #23 is others cat in OSC
   h["TUTORIALS".downcase] = 21.to_s
   h["art"] = 22.to_s 

 return h[jivcatname]
end #def Osc.jivCat2OscCat(gfxnewscatname)



def Osc.bitmeCat2OscCat(bitmecatname)
  bitmecatname=bitmecatname.to_s.downcase
   h = Hash.new("23") #23 is others cat in OSC
   h["TUTORIALS".downcase] = 21.to_s
   h["art"] = 22.to_s 
 return h[bitmecatname]
end #def Osc.bitmeCat2OscCat(bitmecatname)










def Osc.dbprocess(sql)
  #sql=self.txt2Sql(sql.to_s)
  dbh = DBI.connect('DBI:ODBC:osc20090708','root','fav8ht39')
  #dbh = DBI.connect('DBI:ODBC:unidb','ryanTest2','AppleQ3Aj8X4dE')
  #puts sql
  
  dbh.do(sql)  
  dbh.disconnect if dbh
  sql=sql.gsub(/\n|\r/,"\\n")
  file="c:\\tmp\\"+Misc.datenow().split(' ')[0]+".sql_osc20090708"
  sql=sql+";"
  Misc.saveTxt2File(sql,file)
end 



#back a array with selectsql result
def Osc.dbshow(selectsql)
  #selectsql=self.txt2Sql(selectsql.to_s)  
  resultarr=[]
  #puts selectsql
  dbh = DBI.connect('DBI:ODBC:osc20090708','root','fav8ht39')
  #dbh = DBI.connect('DBI:ODBC:unidb','ryanTest2','AppleQ3Aj8X4dE')
  sth = dbh.prepare(selectsql)
  #puts  selectsql
  sth.execute
   while row=sth.fetch do
        #p row
        resultarr << row
    end
   
  dbh.disconnect if dbh


  if resultarr.length > 0
  return resultarr[0][0]
  #puts resultarr[0][0]
  else
  return ""
  end#  if resultarr.length > 0

end #def Osc.dbshow(selectsql)



def Osc.hasProductName(productname)
  productname=Misc.txt2Sql(productname.to_s) 
  sql="SELECT count( * ) \
      FROM `products_description` \
      WHERE `products_name` ="
  sql=sql+productname.to_s
  #puts sql
  
  self.dbshow(sql)
end#=def Osc.ifproductnameExist(productname)





#return 0 if no id find
def Osc.hasId(id)
  id=Misc.txt2Sql(id.to_s) 
  sql="SELECT count( * ) \
      FROM `products` \
      WHERE `products_id` ="
  sql=sql+id.to_s
  #puts sql
  
  self.dbshow(sql)
end#def Osc.hasId(id)


def Osc.hasmyID(id)
  id=Misc.txt2Sql(id.to_s) 
  sql="SELECT count( * ) \
      FROM `products` \
      WHERE `myID` ="
  sql=sql+id.to_s
  #puts sql
  
  self.dbshow(sql)
end#def Osc.hasmyID(id)



#return 0 if no softname find
def Osc.hasSoftname(softname)
  sql="SELECT count( * ) \
      FROM `products_description` \
      WHERE `products_name` ="
  sql=sql+"'"+Misc.txt2Sql(softname.to_s)+"'"
  

  #puts sql
  
  self.dbshow(sql)
end#Osc.hasSoftname(softname)




def Osc.hasId_products_description(id)
  id=Misc.txt2Sql(id.to_s) 
  sql="SELECT count( * ) \
      FROM `products_description` \
      WHERE `products_id` ="
  sql=sql+id.to_s
  #puts sql
  
  self.dbshow(sql)
end #def hasId_products_description(id)


def Osc.hassoftname_description(products_name)
  id=products_name
  id=Misc.txt2Sql(id.to_s) 
  sql="SELECT count( * ) \
      FROM `products_description` \
      WHERE `products_name` ='"
  sql=sql+id.to_s
  sql=sql+"'"
  #puts sql
  
  self.dbshow(sql)
end #def hadsoftname__description(products_name)



def Osc.hasId_products_to_categories(id)
  id=Misc.txt2Sql(id.to_s) 
  sql="SELECT count( * ) \
      FROM `products_to_categories` \
      WHERE `products_id` ="
  sql=sql+id.to_s
  #puts sql
  
  self.dbshow(sql)
end #def OSc.hasId_products_to_categories(id)




def Osc.geteachfileHtmlDesc(myid)
  sql="SELECT `filename` , `filesize` , `sizeunion` FROM `files` WHERE `myID` ="+myid.to_s

if !(Misc.hasFile(myid).to_s == "0".to_s)
   indivifileTablehtml ="<table width=\"100%\" border=\"1\" bgcolor=\"#FFFFEC\">\n      <tr bgcolor=\"#FFFFAC\">\n        <td width=\"80%\"> <div align=\"left\">Title </div></td><td width=\"20%\"><div align=\"left\">Size</div></td>\n      </tr>\n  "  
else
   return ""  
end

  filearray=Misc.getfiles(sql)
  
  
  
  
  filearray.each{|x| 
    filename=x[0]
    filesizeval=x[1]
    filesizeuni=x[2]
    
    indivifileTablehtml=indivifileTablehtml+ " <tr>\n        <td>"+filename
    indivifileTablehtml=indivifileTablehtml+"</td>\n        <td>"+filesizeval+" "+filesizeuni
    indivifileTablehtml=indivifileTablehtml+ " </td>\n      </tr>\n " 
  }
  
  indivifileTablehtml=indivifileTablehtml+    "</table>"
  
end #def Osc.geteachfile(myid)
  


def Osc.getMaxPID()
  sql="SELECT MAX(products_id) FROM products WHERE 1"
  a=self.dbshow(sql)  
end #def Osc.getMaxPID()


#get image from given myid
def Osc.gettitleimg(myid)
sql="SELECT `imagepath`  FROM `images` where `myID`="
sql=sql+myid.to_s
sql=sql+" LIMIT 0 ,1"
result=Misc.dbshow(sql)


if result.length > 0
  return result.split("/")[-1]
else
  return ""
end #if !result.nil?
end #def Osc.gettitleimg(myid)



def Osc.getcatname(myid)
  myid=myid.to_s
  sql="select `category` from `main` where `myID`="
  sql=sql+myid
  Misc.dbshow(sql)
end #def Osc.getproducts_sizenum()



def Osc.getregday(myid)
  myid=myid.to_s
  sql="select `register` from `main` where `myID`="
  sql=sql+myid
  Misc.dbshow(sql)
end #def Osc.getregday(myid)

def Osc.gettotalsizevalue(myid)
  myid=myid.to_s
  sql="select `sizevalue` from `main` where `myID`="
  sql=sql+myid
  Misc.dbshow(sql)
end #def Osc.gettotalsizevalue(myid)



def Osc.gettotalsizeunion(myid)
  myid=myid.to_s
  sql="select `sizeunion` from `main` where `myID`="
  sql=sql+myid
  Misc.dbshow(sql)
end #def Osc.gettotalsizeunion(myid)


def Osc.getfilecount(myid)
  myid=myid.to_s
  sql="select `filecount` from `main` where `myID`="
  sql=sql+myid
  Misc.dbshow(sql)
end #def Osc.getfilecount(myid)



def Osc.getsitename(myid)
  myid=myid.to_s
  sql="select `site` from `main` where `myID`="
  sql=sql+myid
  Misc.dbshow(sql)
end #def Osc.getsitename(myid)




def Osc.getproducts_sizenum(myid)
  myid=myid.to_s
  sql="select `sizevalue`, `sizeunion` from `main` where `myID`="
  sql=sql+myid
  Misc.dbshow(sql)
end #def Osc.getproducts_sizenum()

def Osc.getproducts_sizeunion(myid)
  myid=myid.to_s
  sql="select `sizeunion` from `main` where `myID`="
  sql=sql+myid
  Misc.dbshow(sql)
end #def Osc.getproducts_sizeunion()


def Osc.getsizeInBytes(myid)
  products_sizenum=self.getproducts_sizenum(myid).to_i
  products_sizeunion=self.getproducts_sizeunion(myid).to_s
  
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
  
end #def Osc.getsizeInBytes(myid)


def Osc.calcprice(sizeinbyte)
  sizeinbyte=sizeinbyte.to_i
    if sizeinbyte<=10*1024*1024  #10M
        return "15"
    elsif  sizeinbyte<=100*1024*1024  #300M
        return "20"
    elsif  sizeinbyte<=500*1024*1024  #500M
        return "25"
    elsif  sizeinbyte<=1024*1024*1024  #1G
        return "30"
    elsif  sizeinbyte<=2*1024*1024*1024  #2G
        return "40"
    elsif  sizeinbyte<=4*1024*1024*1024  #4G
        return "50"        
    else 
        return "68"
    end #if sizeinbyte<100
  
end #def Osc.calcprice(sizeinbyte)



def Osc.getproducts_name(myid)
 sql= "SELECT `softname` FROM `main` WHERE `myID`="+myid.to_s
 Misc.dbshow(sql) 
end #def Osc.getproducts_name(myid)



def Osc.insertProduct(myID,products_id,products_image,products_sizenum,products_sizeunion)
#products_id="1"
#products_image="product_img.png"


products_price=self.calcprice(self.getsizeInBytes(myID))

#puts self.getproducts_name(myID)+"_"+self.getcatname(myID)


manufacturers_id=Cmm.publicgetCommManu(self.getproducts_name(myID)+"_"+self.getcatname(myID))
puts "man id is: "+manufacturers_id

products_date_added=Misc.datenow()




products_quantity="10000"
products_weight="0"

sql1=""


sql1= "INSERT INTO `products` "
sql1=sql1 +  "(`myID`,`products_id`, `products_quantity`, `products_model`,"
sql1=sql1 +      "`products_image`, `products_price`, `products_date_added`, "
sql1=sql1 +      " `products_last_modified`, `products_date_available`, `products_weight`,"
sql1=sql1 +      "  `products_status`, `products_tax_class_id`, `manufacturers_id`, `products_ordered`, "
sql1=sql1 +      " `products_sizevalue`, `products_sizeunion`)"
sql1=sql1 +      "  VALUES ("

sql1=sql1 +    myID  #myID
sql1=sql1 +   "," +  products_id  #products_id
sql1= sql1 +  "," +  products_quantity   #products_quantity
sql1= sql1 +  "," +   "''"  #products_model
sql1= sql1 +   "," + "'" + products_image+ "'"  #products_image
sql1= sql1 +  "," +  "'" +   products_price + "'"  #products_price
sql1= sql1 +  "," +   "'"+ products_date_added + "'"  #products_date_added
sql1= sql1 +  "," +   "NULL"  #products_last_modified
sql1= sql1 +  "," +   "NULL"  #products_date_available
sql1= sql1 +  "," +   "'" +  products_weight  + "'"   #   products_weight
sql1= sql1 +  "," +   "1"      #products_status
sql1= sql1 +  "," +   "0"      #products_tax_class_id
sql1= sql1 +  "," + "" + manufacturers_id   +""  #manufacturers_id
sql1= sql1 +  "," +   "0"      #products_ordered
sql1= sql1 +  "," +   "'" +  products_sizenum + "'"     #products_sizevalue
sql1= sql1 +  "," +   "'"+  products_sizeunion+   "'"      #products_sizeunion
sql1= sql1 + ")"

#puts sql1




if Osc.hasId(products_id).to_s == "0".to_s and Osc.hasmyID(myID).to_s=="0"
self.dbprocess(sql1)
else
  puts "id "+products_id.to_s + " have already in table Products"
end #if !Osc.hasId(products_id)

end #def Osc.insertProduct()

def Osc.getDeschtml(myid)
myid=myid.to_s
sql="SELECT `html` FROM `description` where myID="+myid
deschtml=Misc.dbshow(sql)
deschtml=Misc.txt2Sql(deschtml)
return deschtml
end #def Osc.getDeschtml(myid)

def Osc.getproducts_url(myid)
myid=myid.to_s
sql="SELECT `url` FROM `url` where myID="+myid
products_url=Misc.dbshow(sql)
products_url=products_url.downcase
products_url=products_url.gsub(/http:\/\//,"") 
products_url=Misc.txt2Sql(products_url)

if !products_url.nil?
  return products_url
else
  return ""
end #  if !products_url.nil?
end  #def Osc.getproducts_url(myid)




def Osc.assembleFullHDescHtml(myid)
puts "\n============"
puts "myid is: "+myid.to_s
regday=self.getregday(myid).to_s
totalsizevalue=self.gettotalsizevalue(myid)
totalsizeunion=self.gettotalsizeunion(myid)
filenumber=self.getfilecount(myid).to_s
deschtml=self.getDeschtml(myid)
filestablecode=self.geteachfileHtmlDesc(myid)
imgtablecode=self.geteachImgLocalHtmlDesc(myid)

fullhtml= "\n<table width=\"100%\" height=\"100%\" border=\"0\" bgcolor=\"#EAEEFD\">\n  <tr>\n    <td width=\"115\" valign=\"top\">Registered</td>\n    <td width=\"647\">"
fullhtml= fullhtml + regday
fullhtml= fullhtml + "</td>\n  </tr>\n  <tr>\n    <td>Download Size</td>\n    <td>"
fullhtml= fullhtml + totalsizevalue+" "+totalsizeunion
fullhtml= fullhtml + "</td>\n  </tr>\n  "


puts "filenumber: "+filenumber.to_s
if !(filenumber.to_s=="0".to_s)
  fullhtml= fullhtml + "<tr>\n    <td width=\"115\">Files count</td>\n    <td>"
  fullhtml= fullhtml + filenumber+"</td>\n  </tr>\n "
else
  puts "filenumber is 0, will not show in description html code"
end #if !filenumber.to_s=="0"


fullhtml= fullhtml + " <tr>\n    <td width=\"115\" valign=\"top\">Discription</td>\n    <td>"
fullhtml= fullhtml + deschtml
fullhtml= fullhtml + "</td>\n  </tr>\n "
if !(filestablecode=="")
fullhtml= fullhtml + " <tr>\n    <td width=\"115\" valign=\"top\">Included Files</td>\n    <td>"
fullhtml= fullhtml + filestablecode+ "</td>\n  </tr>\n"
end  #if !filestablecode==""

if !(imgtablecode=="")
fullhtml= fullhtml + " <tr>\n    <td width=\"115\" valign=\"top\">ScreenShots</td>\n    <td>"
fullhtml= fullhtml + imgtablecode+ "</td>\n  </tr>\n"
end  #if !filestablecode==""

fullhtml= fullhtml + "</table>\n\n"

#puts fullhtml
  
end #def Osc.assembleFullHDescHtml(myid)


def Osc.insertProducts_description(myid, products_id,products_name,products_description)
#products_id="3"
#products_description="pro's desc"
#products_name="prod's name"

language_id="1"
#product url
products_url=self.getproducts_url(myid)
products_viewed="0"
products_seo_url=""



products_name=Misc.txt2Sql(products_name)
products_description=Misc.txt2Sql(products_description)
products_url=Misc.txt2Sql(products_url)
products_seo_url=Misc.txt2Sql(products_seo_url)




sql2=""


sql2= "INSERT INTO `products_description` "
sql2=sql2 +  "(`products_id`, `language_id`, `products_name`,"
sql2=sql2 +      "`products_description`, `products_url`, `products_viewed`, "
sql2=sql2 +      " `products_seo_url`)" 
sql2=sql2 +      "  VALUES ("

sql2=sql2 +    "'" + products_id + "'"  #products_id
sql2=sql2 +  ", " +  "1"  #language_id
sql2= sql2 +   ", " + "'" + products_name+ "'"  #products_name
sql2= sql2 +   ", " + "'" + products_description+ "'"  #products_description

sql2= sql2 +   ", " + "'" + products_url+ "'"  #products_url
sql2= sql2 +  ", " +   products_viewed  #products_viewed
sql2= sql2 +   ", " + "'" + products_seo_url+ "'"  #products_seo_url


sql2= sql2 + ")"

#puts sql2




if self.hasSoftname(products_name).to_s == "0".to_s and self.hasId_products_description(products_id).to_s=="0" and self.hassoftname_description(products_name).to_s=="0"
self.dbprocess(sql2)
else
  puts products_name.to_s + " have already in table products_description "
end #if Osc.hasSoftname(products_name).to_s == "0".to_s
 
end #def Osc.insertProducts_description()

def Osc.insertProducts_to_categories(insertOscPID,categories_id)
  
  if categories_id.nil?
  categories_id="23" #23 is others 
  end #  if categories_id.nil?
  
  sql3="INSERT INTO `products_to_categories` (`products_id`, `categories_id`) VALUES ("
  sql3=sql3+ "'" + insertOscPID+ "'" +", "
  sql3=sql3+ "'" + categories_id+ "'" 
  sql3=sql3+");"
  

if self.hasId_products_to_categories(insertOscPID).to_s == "0".to_s
  self.dbprocess(sql3)
else
  puts "id"+insertOscPID +" already existed in table products_to_categories"
end #if self.hasId_products_to_categories
  
end #def Osc.insertProducts_to_categories(insertOscPID,categories_id)

def Osc.insertDlpathmap(myID)

  sqlgetarry="SELECT `myID`,`protocol`,`server`,`port`,`ppath`,`path`  FROM `dlpathmap` WHERE `myID` = \""+myID+"\" "
  resultarr=Misc.dbshowWholeArray(sqlgetarry)

  if resultarr.nil?
    puts "no download map inserted to osc, since myID "+myID.to_s+" not found in DB unidb/dlpathmap table "
    return
    else
       

  #p resultarr

        row=resultarr
        myID=  row[0][0].to_s.strip
        protocol=  row[0][1].to_s.strip
        server=  row[0][2].to_s.strip
        port=  row[0][3].to_s.strip
        ppath=  row[0][4].to_s.strip
        path=  row[0][5].to_s.strip
   end
        

        
if (self.hasoscdlpathmap(myID).to_s == "0".to_s)
            
          sql4="INSERT INTO `dlpathmap` ( `myID` , `protocol` , `server` , `port` , `ppath` , `path` )"
          sql4=sql4+"VALUES ('"
          sql4=sql4+myID.to_s.strip
          sql4=sql4+"', '"
          sql4=sql4+ protocol
          sql4=sql4+"', '"
          sql4=sql4+server
          sql4=sql4+"', '"
          sql4=sql4+port
          sql4=sql4+"', '"
          sql4=sql4+ppath
          sql4=sql4+"', '"
          sql4=sql4+path
          sql4=sql4+"');"
 
          self.dbprocess(sql4)
                   
else
puts "myID "+myID.to_s+" already existed in OSC dlpathmap table"          
end  #if !(Misc.hasdlpathmap(myid).to_s == "0".to_s) 
        

 

end #def Osc.insertDlpathmap(myID)



  
def self.hasoscdlpathmap(myid)
  id=Misc.txt2Sql(myid.to_s) 
  sql="SELECT count( * ) \
      FROM `dlpathmap` \
      WHERE `myID` ="
  sql=sql+id.to_s
  #puts sql
  self.dbshow(sql)
end #def self.hasoscdlpathmap(myid)

def Osc.insertMyID(myid)
  myid=myid.to_s
  products_description=self.assembleFullHDescHtml(myid)
#puts products_description

#get OscPID
insertOscPID=(Osc.getMaxPID.to_i+1).to_s
#puts insertOscPID


#get image of title
products_image=Osc.gettitleimg(myid)

#size number and value
products_sizenum=self.getproducts_sizenum(myid)
products_sizeunion=self.getproducts_sizeunion(myid)

#product name
products_name=self.getproducts_name(myid)


#category id
if (self.getsitename(myid)=="verycd")
  categories_id=self.cat2OscCatNum(self.getsitename(myid),self.getcatname(myid))
else
  categories_id=Cmm2.publicgetcatID(self.getproducts_name(myid)+"_"+self.getcatname(myid))
end

puts "categories_id is: "+categories_id




judge= self.hasSoftname(products_name).to_s == "0".to_s and self.hasId_products_description(insertOscPID) ==0 
judge = judge and self.hasId_products_to_categories(insertOscPID).to_s == "0".to_s
judge = judge and self.hasId(insertOscPID).to_s == "0".to_s and self.hasmyID(myid).to_s=="0"

#puts judge
if judge 
  self.insertProduct(myid,insertOscPID,products_image,products_sizenum,products_sizeunion);  
  self.insertProducts_description(myid, insertOscPID,products_name,products_description);  
  self.insertProducts_to_categories(insertOscPID,categories_id)
  self.insertDlpathmap(myid)
else #if judge
  puts "product,product_description,productsToCategory might have duplicate record."
end #if judge 
end #def osc.insertMyID(myid)










def Osc.myID2Products_id(myID)
   if myID.nil?
   	puts "myID is nil ,exit"
   else	
   	myID=myID.to_s.strip
   	sql="SELECT `products_id` FROM `products` WHERE `myID`="+myID
   	products_id=self.dbshow(sql)
   	return products_id
   end #if myID.nil?
end #def Osc.myID2Products_id(myID)


def Osc.Products_id2myID(products_id)
   if products_id.nil?
   	puts "products_id is nil ,exit"
   else	
   	products_id=products_id.to_s.strip
   	sql="SELECT `myID` FROM `products` WHERE `products_id`="+products_id
   	myID=self.dbshow(sql)
   	return myID
   end #if products_idnil?
end #def Osc.Products_id2myID(products_id)





 
def Osc.removeProducts_id(products_id)

products_id=products_id.to_s
puts products_id
myID=self.Products_id2myID(products_id).to_s

if (self.hasId(products_id).to_s == "0".to_s)
   then 
   	puts "products_id "+products_id+" does not existed in osc products table"
   	return
   else
   	self.dbprocess("delete from `products` where `products_id` = "+ products_id)
   	self.dbprocess("delete from `products_description` where `products_id` = " + products_id)
   	self.dbprocess("delete from `products_to_categories` where `products_id` = "+products_id)
   	self.dbprocess("delete from `dlpathmap` where `myID` = " + myID)
   	puts "products_id "+products_id+" was removed from osc"
   end #if (self.hasId(products_id).to_s == "0".to_s)	
end #def Osc.removeProducts_id(products_id)




def Osc.removeMyID(myID)
      if myID.nil?
   	puts "myID is nil,can not delete , exit"
      else	
   	myID=myID.to_s.strip
    myIDinOsc=self.myID2Products_id(myID)
    if (myIDinOsc.nil? or myIDinOsc.to_s=="")
      puts "myID "+myID+" not existed in OSC"
      else
        self.removeProducts_id(myIDinOsc)
      end # if (myIDinOsc.nil? or myIDinOsc.to_s=="")
      
      end  # if myID.nil? 	
end #def Osc.removeMyID(myID)




def Osc.geteachImgLocalHtmlDesc(myid)
  sql="SELECT `imgLclPth` \
      FROM `images` \
      WHERE `myID` ="
  sql=sql+myid.to_s
  sql=sql+" AND `imgLclPth` IS NOT NULL"
  sql=sql+" AND `imgLclPth` NOT LIKE \"dlerr%\""

if !(Misc.hasImgLocal(myid).to_s == "0".to_s)
   individeImgTablehtml ="<table width=\"100%\" border=\"0\">\n "  
else
   return ""  
end

  imglocalArray=Misc.getfiles(sql) #it actual return ImgLocal of the myid, but not files.
  softname=Osc.getproducts_name(myid)

  imglocalArray.each{|x| 
  imglocal="http://61.152.188.156:8088/"+x[0]
   
    individeImgTablehtml=individeImgTablehtml+ " <tr>\n <td> <img src=\""+imglocal+"\" alt=\""+softname+"\"></td></tr>"
 #   individeImgTablehtml=individeImgTablehtml+"<tr><td><p> &NBPS</p></td></tr>" #NBPS DISPLAIED AS CHARACTER FOR CERTERN THEME.
    individeImgTablehtml=individeImgTablehtml+"<tr><td><p> </p></td></tr>"
  }
  
  individeImgTablehtml=individeImgTablehtml+    "</table>"
  return individeImgTablehtml
end #def Osc.geteachImgLocalHtmlDesc(myid)


def Osc.getdllink(myid)
  sql="SELECT * FROM `dlpathmap` WHERE `myID`="+myid.to_s
  rst=Misc.dbshowWholeArray(sql)[0]
  if rst.nil?
    rtn=rst
  else
    #"http://61.152.188.156", "8088", "gweb", "2005-3-8/id1_Ansys-81"
    rtn=rst[1]+"://"+rst[2]+":"+rst[3]+"/"+rst[4]+"/"+rst[5]
  end
    return rtn
end #def Osc.getdllink(myid)


end #end of the module Osc