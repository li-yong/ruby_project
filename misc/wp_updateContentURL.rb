# This script used to update URL in WordPress database post's content from old one 
#  to new one. not regular using.  suppose only need one time
# 
# liyong - 20100318
#
#


$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
$LOAD_PATH << "c:/ruby_project/lib"
require 'DBI'
require 'Misc'
require "wpimprt"

def updatePostContent(postid, postConOri)

linkOri=postConOri.grep(/Are_PayPal_LoginPlease/)[0].split(/\"/)[1]
linkdate=linkOri.split(/\//)[4]
year=linkdate.split(/-/)[0]
month=linkdate.split(/-/)[1]
month="0"+month if month.length < 2 
yearmonth=year+month
linkNew=linkOri.gsub(/gweb/,yearmonth)


puts "== #{postid}  start =="
puts linkOri
puts linkNew

postConNew=postConOri.gsub(linkOri,linkNew)
postConNew=Misc.txt2Sql(postConNew)
#puts postConNew

sql= "UPDATE `wp_posts` SET `post_content` = '#{postConNew}'  WHERE `ID` ='#{postid}'"
#puts sql
Wpimprt.dbprocess(sql)
puts "postid #{postid} was updated"
end






begin
 dbh = DBI.connect('DBI:ODBC:wp29','root','fav8ht39')
 
     sth = dbh.prepare("SELECT * FROM  wp_posts where ID > 9991497")
     sth.execute

 sth.fetch do |row|
       # printf "postid: %s , postcnt: %s \n", row[0],row[4]
        id=row[0]
        con=row[4]      
        updatePostContent(id,con) if con.include?("gweb")
 end  # sth.fetch do |row|
 
 sth.finish

rescue DBI::DatabaseError => e
     puts "An error occurred"
     puts "Error code:    #{e.err}"
     puts "Error message: #{e.errstr}"
ensure
     # disconnect from server
     dbh.disconnect if dbh
end


