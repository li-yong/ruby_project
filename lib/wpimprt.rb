

module Wpimprt
require "misc"
require "iv"
require "cmm"
require "cmm2"

 
 

 







def Wpimprt.dbprocess(sql)
  #sql=self.txt2Sql(sql.to_s)
  dbh = DBI.connect('DBI:ODBC:wp29','root','fav8ht39')
  #dbh = DBI.connect('DBI:ODBC:unidb','ryanTest2','AppleQ3Aj8X4dE')
  #puts sql
  
  dbh.do(sql) 
  dbh.disconnect if dbh
  
  
  
  sql=sql.gsub(/\n|\r/,"\\n")
  file="c:\\tmp\\"+Misc.datenow().split(' ')[0]+".sql_wp29"
  sql=sql+";"
  Misc.saveTxt2File(sql,file)
  
  return  "true"
end 



#back a array with selectsql result
def Wpimprt.dbshow(selectsql)
  #selectsql=self.txt2Sql(selectsql.to_s)  
  resultarr=[]
  #puts selectsql
  dbh = DBI.connect('DBI:ODBC:wp29','root','fav8ht39')
  #dbh = DBI.connect('DBI:ODBC:unidb','ryanTest2','AppleQ3Aj8X4dE')
  sth = dbh.prepare(selectsql)
  puts  selectsql
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









#return 0 if no id find
def Wpimprt.hasId(id)
  id=Misc.txt2Sql(id.to_s) 
  sql="SELECT count( * ) \
      FROM `wp_posts` \
      WHERE `id` ="
  sql=sql+id.to_s
  #puts sql
  
  self.dbshow(sql)
end#def Osc.hasId(id)


def Wpimprt.hasmyID(myid)
  id=Misc.txt2Sql(id.to_s) 
  sql="SELECT count( * ) \
      FROM `myid_postid` \
      WHERE `myID` ="
  sql=sql+myid.to_s
  #puts sql
  
  self.dbshow(sql)
end#def Osc.hasmyID(id)



#return 0 if no softname find
def Wpimprt.hasPostname(postname)
  sql="SELECT count( * ) \
      FROM `wp_posts` \
      WHERE `post_title` ="
  sql=sql+"'"+Misc.txt2Sql(postname.to_s)+"'"
  

  #puts sql
  
  self.dbshow(sql)
end#Osc.hasSoftname(softname)





  


def Wpimprt.getMaxPstID()
  sql="SELECT MAX(ID) FROM `wp_posts` WHERE 1"
  a=self.dbshow(sql)  
end #def Osc.getMaxPstID()

def Wpimprt.getcatcount(catid)
  sql="SELECT `count` FROM `wp_term_taxonomy` WHERE `term_taxonomy_id`=\""+catid+"\""
  a=self.dbshow(sql)  
end #def Osc.getMaxPstID()

 

 
 

def Wpimprt.arepaypalHtmlCode(myid)
  
  dllink=Osc.getdllink(myid)  
  dllink="" if dllink.nil?
  
  htm="<a href=\""
  htm=htm+dllink+"\" target=\"_blank\"><strong>download page</strong></a> "
  htm=htm+"  ,<br>Do _NOT_ directly download by web browser,using download tools instead."
  htm=htm+"<br>contact us if any exception happen."
 
  htm="instant download link not ready for this item, please contact us." if (dllink.nil? or dllink=="")
  rtn="[Are_PayPal_LoginPlease] "+htm+" [/Are_PayPal_LoginPlease] "





end





def Wpimprt.assembleFullHDescHtml(myid)
puts "\n============"
puts "myid is: "+myid.to_s
regday=Osc.getregday(myid).to_s
totalsizevalue=Osc.gettotalsizevalue(myid)
totalsizeunion=Osc.gettotalsizeunion(myid)
filenumber=Osc.getfilecount(myid).to_s
deschtml=Osc.getDeschtml(myid)
filestablecode=Osc.geteachfileHtmlDesc(myid)
imgtablecode=Osc.geteachImgLocalHtmlDesc(myid)

 
downloadsizecode= "  <tr>\n    <td>Download Size</td>\n    <td>"
downloadsizecode= downloadsizecode + totalsizevalue+" "+totalsizeunion
downloadsizecode= downloadsizecode + "</td>\n  </tr>\n  "

downloadsizecode="" if totalsizevalue.to_s=="0"



fullhtml= "\n<table width=\"100%\" height=\"100%\" border=\"0\" bgcolor=\"#EAEEFD\">\n  <tr>\n    <td width=\"115\" valign=\"top\">Registered</td>\n    <td width=\"647\">"
fullhtml= fullhtml + regday
fullhtml= fullhtml + "</td>\n  </tr>\n  "
fullhtml= fullhtml + downloadsizecode

fullhtml= fullhtml + "<tr>\n    <td>Get It</td>\n    <td>"
fullhtml= fullhtml + self.arepaypalHtmlCode(myid)
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





 

def Wpimprt.insertwp_posts(myid,postid)
 
datenow=Misc.datenow()



 
post_author="2" #John,role is author
post_date=datenow
post_date_gmt=datenow
post_content=Misc.txt2Sql(self.assembleFullHDescHtml(myid))
post_title=Misc.txt2Sql(Osc.getproducts_name(myid))
post_excerpt=""
post_status="publish"
comment_status="open"
ping_status="open"
post_password=""
post_name=Iv.cygwindlname(post_title)
to_ping=""
pinged=""
post_modified=datenow
post_modified_gmt=datenow
post_content_filtered=""
post_parent="0"
guid=""
menu_order="0"
post_type="post"
post_mime_type=""
comment_count="0"


sql2="INSERT INTO `wp_posts` ( `ID` , `post_author` , `post_date` , `post_date_gmt` , \
`post_content` , `post_title` , `post_excerpt` , `post_status` , \
`comment_status` , `ping_status` , `post_password` , `post_name` ,\
`to_ping` , `pinged` , `post_modified` , `post_modified_gmt` , \
`post_content_filtered` , `post_parent` , `guid` , `menu_order` , \
`post_type` , `post_mime_type` , `comment_count` ) \
VALUES (" 
sql2=sql2 +    "'" + postid + "',"  
sql2=sql2 +    "'" + post_author + "',"  
sql2=sql2 +    "'" + post_date + "',"  
sql2=sql2 +    "'" + post_date_gmt+ "',"  
sql2=sql2 +    "'" + post_content + "',"  
sql2=sql2 +    "'" + post_title + "',"  
sql2=sql2 +    "'" + post_excerpt + "',"  
sql2=sql2 +    "'" + post_status+ "',"  
sql2=sql2 +    "'" + comment_status + "',"  
sql2=sql2 +    "'" + ping_status + "',"  
sql2=sql2 +    "'" + post_password + "',"  
sql2=sql2 +    "'" + post_name + "',"  
sql2=sql2 +    "'" + to_ping + "',"  
sql2=sql2 +    "'" + pinged + "',"  
sql2=sql2 +    "'" + post_modified + "',"  
sql2=sql2 +    "'" + post_modified_gmt + "',"  
sql2=sql2 +    "'" + post_content_filtered + "',"  
sql2=sql2 +    "'" + post_parent + "',"  
sql2=sql2 +    "'" + guid + "',"  
sql2=sql2 +    "'" + menu_order + "',"  
sql2=sql2 +    "'" + post_type + "',"  
sql2=sql2 +    "'" + post_mime_type + "',"  
sql2=sql2 +    "'" + comment_count + "'"   

sql2= sql2 + ")"

#puts sql2


 self.dbprocess(sql2)  
 puts "inserted to wp_posts, myid: #{myid},postid:#{postid})"
 
end #def Osc.insertProducts_description()

 
 
def Wpimprt.insertmyid_postid(myid,postid)
  sql3="INSERT INTO `myid_postid` (`myID`, `postid`) VALUES ("
  sql3=sql3+ "'" + myid.to_s+ "'" +", "
  sql3=sql3+ "'" + postid.to_s+ "'" 
  sql3=sql3+");"  
  self.dbprocess(sql3)
   puts "inserted to myid_postid, myid: #{myid},postid:#{postid})"
end  
 


  


def Wpimprt.insertwp_term_taxonomy(myid,postid)
   softname=Osc.getproducts_name(myid)
   catid=Cmm2.publicgetcatID(softname)
   term_order="0"
   
   sql4="INSERT INTO `wp_term_relationships` ( `object_id` , `term_taxonomy_id` , `term_order` ) VALUES ("
   sql4=sql4+ "'" + postid.to_s+ "'" +", "
   sql4=sql4+ "'" + catid.to_s+ "'" +", "
   sql4=sql4+ "'" + term_order.to_s+ "'" 
   sql4=sql4+");"
   self.dbprocess(sql4)
    puts "inserted to wp_term_relationships, postid:#{postid}, catid: #{catid})"
   
   count=(self.getcatcount(catid).to_i+1).to_s
    sql5="UPDATE `wp_term_taxonomy` SET `count` = "
    sql5=sql5+"'"+count+"'"
    sql5=sql5+" WHERE `term_taxonomy_id` ="
    sql5=sql5+"'"+catid.to_s+"'"
   self.dbprocess(sql5)
   puts "update term_taxonomy, add 1 for products # under this category"
end #def Wpimprt.insertwp_term_taxonomy(myid,postid)




def Wpimprt.insertwp_are_paypal_items(myid, postid)

products_price=Osc.calcprice(Osc.getsizeInBytes(myid))
products_price=products_price.to_i * 0.3 
products_price=6.8 if products_price < 6.8
products_price=products_price * 2

  id="NULL"
  post_id=postid 
  name="" 
  number=""  
  amount=products_price.to_s
  currency="USD"  
  expire="0" 
  expiration_unit="D"
  
   sql6="INSERT INTO `wp_are_paypal_items` ( `id` , `post_id` , `name` , `number` , `amount` , `currency` , `expire` , `expiration_unit` )VALUES ("
   sql6=sql6+ id +", "
   sql6=sql6+ "'" + post_id.to_s+ "'" +", "
   sql6=sql6+ "'" + name.to_s+ "'" +", "
   sql6=sql6+ "'" + number.to_s+ "'" +", "
   sql6=sql6+ "'" + amount.to_s+ "'" +", "
   sql6=sql6+ "'" + currency.to_s+ "'" +", "
   sql6=sql6+ "'" + expire.to_s+ "'" +", "
   sql6=sql6+ "'" + expiration_unit.to_s+ "'" 
   sql6=sql6+");"
   self.dbprocess(sql6)
  puts "inserted to  wp_are_paypal_items,  postid:#{postid}, price:#{amount} usd)"


end #def def Wpimprt.insertwp_term_taxonomy(myid,postid)

def Wpimprt.insertMyID(myid)
  myid=myid.to_s
  postid=(self.getMaxPstID.to_i+1).to_s
  postname=Osc.getproducts_name(myid)
  
 
 



judge= self.hasPostname(postname).to_s == "0".to_s  
judge = judge and self.hasId(postid).to_s == "0".to_s
judge = judge and self.hasmyID(myid).to_s == "0".to_s  
#puts judge
if judge 
  self.insertwp_posts(myid,postid);  
  self.insertwp_term_taxonomy(myid,postid)
  self.insertwp_are_paypal_items(myid,postid)
  self.insertmyid_postid(myid,postid)
else #if judge
  puts "wp_post->post_name,wp_post->id, or myid_postid->myid might have duplicate record."
end #if judge 
end #def osc.insertMyID(myid)



            def Wpimprt.getPostidFromMyID(odbc,myid)
              myid=myid.to_s
              sql="select `postid` from `myid_postid` where `myID`="
              sql=sql+myid
              Misc.dbshowCommon(odbc,sql)
            end #def Wpimprt.getPostidFromMyID(odbc,myid)
            

def Wpimprt.removeByMyID(odbc,myid)
  postId=self.getPostidFromMyID(odbc,myid)
  if postId.nil?
    puts "not records in tbl myid_postid for myid=#{myid}"
    return
  end
  puts "removing postid #{postId}, myID #{myid}"
  Misc.dbprocessCommon(odbc,"delete from `wp_are_paypal_items` where `post_id` = "+ postId)
  Misc.dbprocessCommon(odbc,"delete from `wp_postmeta` where `post_id` = " + postId)
  Misc.dbprocessCommon(odbc,"delete from `wp_posts` where `ID` = "+postId)
  Misc.dbprocessCommon(odbc,"delete from `myid_postid` where `postid` = "+postId)  
  Misc.dbprocessCommon(odbc,"delete from `wp_term_relationships` where `object_id`  = "+postId)  
  
  
   
  
end #def Wpimprt.removeByMyID(odbc,postobject_id Id)


 
def Wpimprt.removeBrokenLinkPost(startMyID)
  startID=0 if startID.nil?

  sqlUnidb="select myID from dlpathmap where valid=0 "
  sqlWp29="select myID from myid_postid where myID>=#{startMyID} "
 
  arrUnidb = Misc.dbshowMultiResultsCommon("unidb",sqlUnidb)
  arrWp29  = Misc.dbshowMultiResultsCommon("wp29",sqlWp29)
  
  arrDel=arrUnidb & arrWp29
  
  puts arrDel
  
  arrDel.each{|myID2Del|
     self.removeByMyID("wp29",myID2Del);  
     }
   
end

#clean `wp_term_relationships` tbl, remove entry that not exist in 'wp_posts'
def Wpimprt.cleanUpWp_term_relationships(startMyID)
  startID=0 if startID.nil?

  sqlWp29_wp_term_rel="select object_id from wp_term_relationships where object_id>=#{startMyID} "
  sqlWp29_wp_posts="select ID from wp_posts where ID>=#{startMyID} "

 
  arrWp29_wp_posts  = Misc.dbshowMultiResultsCommon("wp29",sqlWp29_wp_posts)
  arrWp29_wp_term_rel  = Misc.dbshowMultiResultsCommon("wp29",sqlWp29_wp_term_rel)

  
  arrDel= arrWp29_wp_term_rel - arrWp29_wp_posts
    
  arrDel.each{|myID2Del|
     Misc.dbprocessCommon(odbc,"delete from `wp_term_relationships` where `object_id`  = "+myID2Del)  
     }
   
end





end #end of the module Wpimprt