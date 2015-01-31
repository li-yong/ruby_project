


$LOAD_PATH << File.dirname(__FILE__).to_s+"/lib"
$LOAD_PATH << "c:/ruby_project/lib"
require 'DBI'
require 'Misc'
require 'net/http'
require 'uri'

require "wpimprt"

def checkURLinpost(postConOri)

linkOri=postConOri.grep(/Are_PayPal_LoginPlease/)[0].split(/\"/)[1]

txt=Id.to_s+", http://www.files24x7.com/"+Post_name+"  => "+linkOri

if validlink(linkOri) == true 
  Misc.saveTxt2File(txt,Okfile)
else
  Misc.saveTxt2File(txt,Brokenfile)
end  #if validlink(linkOri) == true 

end



def validlink(url)
  rtn=true 
  html=Net::HTTP.get(URI.parse(url))
  rtn=false if  html.include?("was not found on this server")
  puts "not found"
return rtn
  
end  #def validlink(url)



begin

Okfile="c:/tmp/linkok.txt"
Brokenfile="c:/tmp/linkbroken.txt"

File.delete(Okfile) if File.exist?(Okfile)

File.delete(Brokenfile) if File.exist?(Brokenfile)



 dbh = DBI.connect('DBI:ODBC:wp29','root','fav8ht39')
 
     sth = dbh.prepare("SELECT * FROM  wp_posts where ID >= 5000 ")
     sth.execute

 sth.fetch do |row|
       # printf "postid: %s , postcnt: %s \n", row[0],row[4]
        Id=row[0]
        con=row[4]      
        #post_title=row[5]
        Post_name=row[11]
        checkURLinpost(con) if con.include?("61.152.188.156")
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


