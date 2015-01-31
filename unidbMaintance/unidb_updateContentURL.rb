# This script used to update URL in unidb database post's content from old one 
#  to new one. not regular using.  suppose only need one time
# 
# liyong - 20100318
#
#


$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
$LOAD_PATH << "c:/ruby_project/lib"
require 'DBI'
require 'Misc'
#require "wpimprt"

def updatePostContent(postid, postConOri)

linkdate=postConOri.split(/\//)[0]
year=linkdate.split(/-/)[0]
month=linkdate.split(/-/)[1]
month="0"+month if month.length < 2 
yearmonth=year+month 

puts "== #{postid}  start =="

#puts postConNew

sql= "UPDATE `dlpathmap` SET `ppath` = '#{yearmonth}'  WHERE `myID` ='#{postid}'"
#puts sql
Misc.dbprocess(sql)
puts "postid #{postid} was updated"
end






begin
 dbh = DBI.connect('DBI:ODBC:unidb','root','fav8ht39')
 
     sth = dbh.prepare("SELECT * FROM  dlpathmap where myID > 1 ")
     sth.execute

 sth.fetch do |row|
       # printf "postid: %s , postcnt: %s \n", row[0],row[4]
        id=row[0]
        con=row[5]    
       puts con        
        updatePostContent(id,con) if con.include?("\/")
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


